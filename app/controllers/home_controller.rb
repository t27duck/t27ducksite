class HomeController < ApplicationController
  def index
    @posts = Post.published.order(published_at: :desc).limit(5)
  end
end
