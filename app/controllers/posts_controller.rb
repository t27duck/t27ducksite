class PostsController < ApplicationController
  before_action :fetch_posts, only: [:index, :tag]

  def index
    @page_title = 'Blog Entries'
    respond_to do |format|
      format.html do
        @no_content = true
        @posts = @posts.page(params[:page]).per(5)
      end
      format.xml do
        render layout: false
      end
    end
  end

  def show
    @post             = Post.find(params[:id])
    @page_title       = @post.title
    @page_description = @post.summary
    @page_type        = 'article'
  end

  def tag
    @tag        = Tag.find_by!(name: params[:tag].downcase.strip)
    @posts      = @posts.joins(:tags).where(tags: { name: @tag.name }).page(params[:page]).per(5)
    @page_title = "Blog Entries for tag: '#{@tag.name}'"
    render :index
  end

  private ######################################################################

  def fetch_posts
    @posts = Post.includes(:tags).published.order(published_at: :desc)
  end
end
