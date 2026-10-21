class DesktopController < ApplicationController
  include DesktopOpeners

  allow_unauthenticated_access
  layout "desktop"

  # open is the path of a page on the site to boot into, opened in its program:
  # the easter egg (easter_egg_controller.js) passes the page it fired on.
  def show
    @windows = Desktop::Window.configured
    @recent_posts = Post.post.published.order(published_at: :desc).limit(5)
    @opening = page_to_open&.then { opener_for(it) }
  end

  private ######################################################################

  # The post or project at params[:open], if it's one this site shows.
  def page_to_open
    path = params[:open].to_s
    return unless path.start_with?("/") && !path.start_with?("//") # recognize_path takes a full URL's path too

    route = Rails.application.routes.recognize_path(path)
    case route.values_at(:controller, :action)
    in ["posts", "show"] then Post.published.find_by(id: route[:id].to_i)
    in ["projects", "show"] then Project.find_by(id: route[:id].to_i)
    else nil
    end
  rescue ActionController::RoutingError
    nil
  end
end
