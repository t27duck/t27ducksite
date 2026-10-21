# Which desktop program opens a file: talks play in the Media Player, posts and
# projects browse in Internet Explorer.
module DesktopOpeners
  extend ActiveSupport::Concern

  included do
    helper_method :opener_for
  end

  private ######################################################################

  # The program's Desktop::Window, with src set to load file into it.
  def opener_for(file)
    case file
    in Project then program("internet_explorer").with(src: desktop_internet_explorer_path(project: file))
    in Post if file.talk? then program("media_player").with(src: desktop_media_player_path(talk: file))
    in Post then program("internet_explorer").with(src: desktop_internet_explorer_path(post: file))
    end
  end

  def program(name)
    (@programs ||= {})[name] ||= Desktop::Window.find(name)
  end
end
