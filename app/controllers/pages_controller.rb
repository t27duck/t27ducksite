class PagesController < ApplicationController
  allow_unauthenticated_access

  def show
    @page = Page.find_by!(slug: params.expect(:id).downcase)
    @page_title = @page.title
  end
end
