module ApplicationHelper
  def markdown(template)
    renderer = CodeRayify.new(filter_html: true, hard_wrap: true)

    options = {
      fenced_code_blocks: true,
      no_intra_emphasis:  true,
      autolink:           true,
      lax_html_blocks:    true
    }

    Redcarpet::Markdown.new(renderer, options).render(template).html_safe
  end
end
