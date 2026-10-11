class TalksController < ApplicationController
  def index
    @page_title = "Talks and Presentations"
    @talks = Post.where(kind: "talk").includes(:tags).published.order(published_at: :desc).page(params[:page]).per(10)
  end
end
