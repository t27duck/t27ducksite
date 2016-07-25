module ApplicationHelper
  MARKDOWN_OPTIONS = {
    fenced_code_blocks: true,
    no_intra_emphasis:  true,
    autolink:           true,
    lax_html_blocks:    true,
    tables:             true,
    link_attributes:    { target: '_blank' }
  }.freeze

  def markdown(template)
    renderer = CodeRayify.new(filter_html: true, hard_wrap: true)

    Redcarpet::Markdown.new(renderer, MARKDOWN_OPTIONS).render(template).html_safe
  end
end
