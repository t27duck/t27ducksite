class CodeRayify < Redcarpet::Render::HTML
  def block_code(code, language)
    language = 'none' if language.nil?
    CodeRay.scan(code, language).div
  end
end
