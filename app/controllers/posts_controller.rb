class PostsController < ApplicationController
  allow_unauthenticated_access

  def index
    @page_title = "Blog Entries"
    @posts = Post.post.published.order(published_at: :desc)

    respond_to do |format|
      format.html { @posts = @posts.page(params[:page]).per(10) }
      format.xml { render layout: false }
    end
  end

  def show
    posts             = authenticated? ? Post.all : Post.published
    @post             = posts.includes(:tags).with_rich_text_content_and_embeds.find(params.expect(:id))
    @page_title       = @post.title
    @page_description = @post.summary
    @page_type        = "article"
  end
end
