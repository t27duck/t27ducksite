# frozen_string_literal: true

class PagesController < ApplicationController
  def show
    @page = Page.find_by!(slug: params.expect(:id).downcase)
    @page_title = @page.title
  end
end
