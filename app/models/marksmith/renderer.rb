# frozen_string_literal: true

module Marksmith
  class Renderer
    def initialize(body:)
      @body = body
    end

    def render
      # commonmarker expects an utf-8 encoded string
      body = @body.to_s.dup.force_encoding("utf-8")
      Commonmarker.to_html(body, options: {
                             extension: { tagfilter: false },
                             render: { unsafe: true }
                           })
    end
  end
end
