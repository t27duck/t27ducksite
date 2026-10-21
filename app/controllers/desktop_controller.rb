class DesktopController < ApplicationController
  allow_unauthenticated_access
  layout "desktop"

  def show
    @windows = Desktop::Window.configured
    @recent_posts = Post.post.published.order(published_at: :desc).limit(5)
    @internet_explorer = Desktop::Window.find("internet_explorer")
  end
end
