class MovePageContentToActionText < ActiveRecord::Migration[8.1]
  # Local copies so this migration never depends on future app code.
  class MigrationPage < ActiveRecord::Base
    self.table_name = "pages"
  end

  class MigrationRichText < ActiveRecord::Base
    self.table_name = "action_text_rich_texts"
  end

  # Prism (bundled with Lexxy) has no grammar for these, but does for the target.
  LANGUAGE_MAP = { "erb" => "markup", "psql" => "sql" }.freeze

  def up
    MigrationPage.reset_column_information
    MigrationRichText.reset_column_information

    MigrationPage.find_each do |page|
      next if page.content.blank?
      next if MigrationRichText.exists?(record_type: "Page", record_id: page.id, name: "content")

      now = Time.current
      MigrationRichText.create!(
        record_type: "Page",
        record_id: page.id,
        name: "content",
        body: markdown_to_action_text_html(page.content),
        created_at: now,
        updated_at: now
      )
    end

    change_column_null :pages, :content, true
  end

  def down
    change_column_null :pages, :content, false
    MigrationRichText.where(record_type: "Page", name: "content").delete_all
  end

  private

  def markdown_to_action_text_html(markdown)
    # syntax_highlighter: nil turns off commonmarker's built-in highlighter, which
    # would otherwise emit inline style attributes. Lexxy highlights client-side
    # with Prism instead.
    html = Commonmarker.to_html(
      markdown.to_s.dup.force_encoding("utf-8"),
      options: { extension: { tagfilter: false }, render: { unsafe: true } },
      plugins: { syntax_highlighter: nil }
    )

    fragment = Nokogiri::HTML5.fragment(html)

    fragment.css("h1, h2, h3, h4, h5, h6").each do |heading|
      heading.remove_attribute("id")
      heading.css("a.anchor").each(&:remove)
    end

    fragment.css("pre").each { |pre| rewrite_code_block(pre) }

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
end
