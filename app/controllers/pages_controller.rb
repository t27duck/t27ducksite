class PagesController < ApplicationController
  def show
    @page = Page.find_by!(slug: params[:id].downcase)
    @page_title = @page.title
  end
end
