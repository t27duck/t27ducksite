# frozen_string_literal: true

class CodeRayify < Redcarpet::Render::HTML
  def block_code(code, language)
    language = "none" if language.nil?
    CodeRay.scan(code, language).div
  end

  def table(header, body)
    '<table class="table">' \
      "<thead>#{header}</thead>" \
      "<tbody>#{body}</tbody>" \
      "</table>"
  end
end
