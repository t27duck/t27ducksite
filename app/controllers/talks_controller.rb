class TalksController < ApplicationController
  allow_unauthenticated_access

  def index
    @page_title = "Talks and Presentations"
    @talks = Post.talk.published.includes(:tags).order(published_at: :desc).page(params[:page]).per(10)
  end
end
