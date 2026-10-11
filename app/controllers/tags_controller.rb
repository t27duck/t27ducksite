class TagsController < ApplicationController
  allow_unauthenticated_access

  def show
    @tag        = Tag.find_by!(name: params.expect(:id).parameterize)
    @posts      = @tag.posts.post.published.order(published_at: :desc).page(params[:page]).per(10)
    @page_title = "Blog Entries for tag: '#{@tag.name}'"
  end
end
