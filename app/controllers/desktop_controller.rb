class DesktopController < ApplicationController
  allow_unauthenticated_access
  layout "desktop"

  def show
    @recent_posts = Post.post.published.order(published_at: :desc).limit(5)
  end
end
