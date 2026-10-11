class Admin::PagesController < Admin::BaseController
  before_action :set_page, only: [:edit, :update]

  def index
    @pages = Page.order(:slug)
  end

  def edit
  end

  def update
    if @page.update(page_params)
      redirect_to admin_pages_path, notice: "Page was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  private ######################################################################

  def set_page
    @page = Page.find(params.expect(:id))
  end

  def page_params
    params.expect(page: [:title, :content])
  end
end
