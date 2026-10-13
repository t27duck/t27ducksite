class DesktopController < ApplicationController
  allow_unauthenticated_access
  layout "desktop"

  def show
    @posts = Post.post.published.order(published_at: :desc)
    @talks = Post.talk.published.order(published_at: :desc)
    @projects = Project.order(:created_at)
    @recent_posts = @posts.limit(5)
  end
end
