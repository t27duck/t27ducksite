class Desktop::FoldersController < ApplicationController
  allow_unauthenticated_access

  def show
    @folder = params[:id]
    @files = files_in(@folder)
    @media_player = Desktop::Window.find("media_player") if @folder == "talks"
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
