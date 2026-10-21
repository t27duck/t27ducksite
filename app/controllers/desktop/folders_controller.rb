class Desktop::FoldersController < ApplicationController
  include DesktopOpeners

  allow_unauthenticated_access

  def show
    @folder = params[:id]
    @files = files_in(@folder)
  end

  private ######################################################################

  def files_in(folder)
    case folder
    when "posts" then Post.post.published.order(published_at: :desc)
    when "talks" then Post.talk.published.order(published_at: :desc)
    when "projects" then Project.order(:created_at)
    end
  end
end
