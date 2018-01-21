class TalksController < ApplicationController
  def index
    @page_title = 'Talks and Presentations'
    @talks = Talk.order(:presented_on).page(params[:page]).per(3)
  end
end
