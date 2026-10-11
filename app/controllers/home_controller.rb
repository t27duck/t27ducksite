class HomeController < ApplicationController
  def index
    @posts = Post.published.order(published_at: :desc).limit(12)
    @projects = Project.order(:created_at)
  end
end
