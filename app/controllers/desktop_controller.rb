class DesktopController < ApplicationController
  allow_unauthenticated_access
  layout "desktop"

  def show
    @windows = Desktop::Window.configured
    @recent_posts = Post.post.published.order(published_at: :desc).limit(5)
  end
end
