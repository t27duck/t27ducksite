class Admin::PagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_page, only: [:edit, :update]

  def index
    @pages = Page.order(:slug)
  end

  def edit
  end

  def update
    if @page.update(page_params)
      redirect_to admin_pages_path, notice: 'Page was successfully updated.'
    else
      render :edit
    end
  end

  def preview
    @content = params[:content]
    render layout: false
  end

  private ######################################################################

  def set_page
    @page = Page.find(params[:id])
  end

  def page_params
    params.require(:page).permit(:title, :content)
  end
end
