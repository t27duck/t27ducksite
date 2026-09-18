class MovePostContentToActionText < ActiveRecord::Migration[8.1]
  # Local copy so this migration never depends on future app code. It also has to
  # read posts.content, which Post stops exposing once has_rich_text is added.
  class MigrationPost < ActiveRecord::Base
    self.table_name = "posts"
  end

  # Prism (bundled with Lexxy) has no grammar for these, but does for the target.
  LANGUAGE_MAP = { "erb" => "markup", "psql" => "sql" }.freeze

  # A few old headings were written as "###Preperation" with no space, which
  # CommonMark does not treat as a heading. Excluding "!" keeps "#!/bin/bash"
  # inside a fenced block from being promoted to one. Do NOT loosen this to
  # (?=\S) -- it backtracks and mangles every other heading in the corpus.
  HEADING_WITHOUT_SPACE = /^(\#{1,6})(?=[^#\s!])/

  BLOB_URL   = %r{\A/rails/active_storage/blobs/redirect/([^/]+)/(.+)\z}
  YOUTUBE_ID = %r{youtube\.com/(?:embed/|watch\?v=)([A-Za-z0-9_-]{11})}

  def up
    MigrationPost.reset_column_information

    ActiveRecord::Base.no_touching do
      MigrationPost.find_each do |post|
        post.kind == "talk" ? migrate_talk(post) : migrate_post(post)
      end
    end

    # New posts are written through Action Text and never populate this column.
    # The legacy markdown stays in place as the rollback path.
    change_column_null :posts, :content, true
  end

  def down
    change_column_null :posts, :content, false if MigrationPost.where(content: nil).none?

    # delete_all, not destroy_all: has_many_attached :embeds defaults to
    # dependent: :purge_later, which would delete the image files themselves.
    ActiveStorage::Attachment.where(record_type: "ActionText::RichText", name: "embeds").delete_all
    ActionText::RichText.where(record_type: "Post", name: "content").delete_all
    MigrationPost.update_all(video_url: nil)
  end

  private ######################################################################

  def migrate_talk(post)
    return if post.video_url.present?

    youtube_id = post.content.to_s[YOUTUBE_ID, 1]
    raise "Talk #{post.id} has no YouTube URL in its content" if youtube_id.blank?

    post.update_column(:video_url, "https://www.youtube.com/watch?v=#{youtube_id}")
  end

  def migrate_post(post)
    return if post.content.blank?
    return if ActionText::RichText.exists?(record_type: "Post", record_id: post.id, name: "content")

    # The real model, not a raw insert like the page migration used: its
    # before_validation callback is what attaches the embedded blobs, which is
    # the whole reason the images become attachments instead of bare <img> tags.
    ActionText::RichText.create!(
      record_type: "Post",
      record_id: post.id,
      name: "content",
      body: markdown_to_action_text_html(post.content)
    )
  end

  def markdown_to_action_text_html(markdown)
    # syntax_highlighter: nil turns off commonmarker's built-in highlighter, which
    # would otherwise emit inline style attributes. Lexxy highlights client-side
    # with Prism instead.
    html = Commonmarker.to_html(
      markdown.to_s.dup.force_encoding("utf-8").gsub(HEADING_WITHOUT_SPACE, '\1 '),
      options: { extension: { tagfilter: false }, render: { unsafe: true } },
      plugins: { syntax_highlighter: nil }
    )

    fragment = Nokogiri::HTML5.fragment(html)

    fragment.css("h1, h2, h3, h4, h5, h6").each do |heading|
      heading.remove_attribute("id")
      heading.css("a.anchor").each(&:remove)
    end

    fragment.css("pre").each { |pre| rewrite_code_block(pre) }
    # After the pre pass, so an <img> written inside a code block has already
    # been flattened to text and can't be mistaken for a real image.
    fragment.css("img").each { |img| rewrite_image(img) }

    fragment.to_html.strip
  end

  # Lexical reads the code block language from data-language only, and exports
  # code blocks as a bare <pre> with <br> line breaks. Match that so the content
  # round-trips through the editor.
  def rewrite_code_block(pre)
    code     = pre.at_css("code")
    source   = (code || pre).text
    language = pre["lang"] || code&.[]("class").to_s[/language-([\w+-]+)/, 1]
    language = LANGUAGE_MAP.fetch(language, language)

    pre.attributes.each_key { |name| pre.remove_attribute(name) }
    pre["data-language"] = language if language.present?

    pre.children.unlink
    source.chomp("\n").split("\n", -1).each_with_index do |line, index|
      pre.add_child(Nokogiri::XML::Node.new("br", pre.document)) if index.positive?
      pre.add_child(Nokogiri::XML::Text.new(line, pre.document))
    end
  end

  # marksmith stored uploads as plain <img> tags pointing at the blob redirect
  # route, written directly or through markdown image syntax. Action Text wants
  # attachment nodes, so the blobs end up owned by the rich text record instead
  # of sitting unreferenced in active_storage_blobs.
  def rewrite_image(img)
    blob = blob_for(img["src"])
    raise "Cannot resolve a blob for #{img["src"].inspect}" if blob.nil?

    alt = img["alt"].to_s.strip
    # Most old alt text is just the filename, which would render as a pointless
    # caption. Only carry over alt text that says something.
    attributes = alt.present? && alt != blob.filename.to_s ? { caption: alt } : {}

    # A markdown image is the only child of its own <p>. Leaving the attachment
    # there would nest the rendered <figure> inside a <p>, which the HTML parser
    # splits back apart into stray empty paragraphs.
    target = img.parent
    target = img unless target.name == "p" &&
                        target.children.reject { |n| n.text? && n.text.strip.empty? } == [img]

    target.replace(ActionText::Attachment.from_attachable(blob, attributes).node.to_s)
  end

  def blob_for(src)
    match = BLOB_URL.match(src.to_s.split("?").first.to_s)
    return nil if match.nil?

    # Signed ids are tied to secret_key_base, and these were minted in whichever
    # environment the upload happened in. find_signed works today in development,
    # but fall back to the id carried in the payload -- checked against the
    # filename in the URL -- so this behaves the same wherever it runs.
    ActiveStorage::Blob.find_signed(match[1]) ||
      ActiveStorage::Blob.find_by(id: unverified_blob_id(match[1]), filename: CGI.unescape(match[2]))
  end

  def unverified_blob_id(signed_id)
    payload = JSON.parse(signed_id.split("--").first.to_s.tr("-_", "+/").unpack1("m"))
    payload.dig("_rails", "data") if payload.dig("_rails", "pur") == "blob_id"
  rescue JSON::ParserError, ArgumentError, TypeError
    nil
  end
end
