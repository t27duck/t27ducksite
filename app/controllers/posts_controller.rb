class PostsController < ApplicationController
  before_action :set_post, only: [:show]

  def index
    @posts      = Post.published.order(published_at: :desc).page(params[:page]).per(5)
    @page_title = 'Blog Entries'
  end

  def show
    @page_title       = @post.title
    @page_description = @post.summary
    @page_type        = 'article'
  end

  private ######################################################################

  def set_post
    @post = Post.find(params[:id])
  end
end
