class HomeController < ApplicationController
  allow_unauthenticated_access

  def index
    @posts = Post.published.order(published_at: :desc).limit(12)
    @projects = Project.order(:created_at)
  end
end
