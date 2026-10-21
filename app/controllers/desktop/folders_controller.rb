class Desktop::FoldersController < ApplicationController
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

  # The program window a file opens in: talks play in the Media Player, posts
  # and projects browse in Internet Explorer.
  helper_method def opener_for(file)
    case @folder
    when "talks" then program("media_player").with(src: desktop_media_player_path(talk: file))
    when "posts" then program("internet_explorer").with(src: desktop_internet_explorer_path(post: file))
    when "projects" then program("internet_explorer").with(src: desktop_internet_explorer_path(project: file))
    end
  end

  def program(name)
    (@programs ||= {})[name] ||= Desktop::Window.find(name)
  end
end
