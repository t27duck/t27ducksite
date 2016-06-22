class PostsController < ApplicationController
  before_action :set_post, only: [:show]

  def index
    @posts = Post.published.order(published_at: :desc).page(params[:page]).per(5)
  end

  def show
  end

  private ######################################################################

  def set_post
    @post = Post.find(params[:id])
  end
end
