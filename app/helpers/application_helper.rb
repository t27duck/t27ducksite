# frozen_string_literal: true

module ApplicationHelper
  MARKDOWN_OPTIONS = {
    fenced_code_blocks: true,
    no_intra_emphasis: true,
    autolink: true,
    lax_html_blocks: true,
    tables: true,
    strikethrough: true,
    link_attributes: { target: "_blank" }
  }.freeze

  def markdown(template)
    renderer = CodeRayify.new(filter_html: false, hard_wrap: true)

    Redcarpet::Markdown.new(renderer, MARKDOWN_OPTIONS).render(template).html_safe # rubocop:disable Rails/OutputSafety
  end

  def tag_links(tags)
    tags.map do |tag|
      link_to tag.name, tag_posts_path(tag.name)
    end.join(", ").html_safe # rubocop:disable Rails/OutputSafety
  end
end
