module ApplicationHelper
  def markdown(template)
    renderer = CodeRayify.new(
      filter_html:  true,
      hard_wrap:    true
    )

    options = {
      fenced_code_blocks: true,
      no_intra_emphasis:  true,
      autolink:           true,
      lax_html_blocks:    true
    }

    markdown_to_html = Redcarpet::Markdown.new(renderer, options)
    markdown_to_html.render(template).html_safe
  end
end
