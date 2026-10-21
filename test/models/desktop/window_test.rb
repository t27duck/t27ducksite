require "test_helper"

class Desktop::WindowTest < ActiveSupport::TestCase
  test "configured reads the windows from config in order" do
    assert_equal ["posts", "talks", "projects", "solitaire", "media_player", "internet_explorer"], Desktop::Window.configured.map(&:name)
  end

  test "find looks a window up by name" do
    assert_equal "Media Player", Desktop::Window.find("media_player").title
    assert_raises(KeyError) { Desktop::Window.find("minesweeper") }
  end

  test "to_params is what desktop_controller.js builds the window from" do
    window = Desktop::Window.configured.first

    assert_equal({ id: "posts-window", title: "Posts", src: "/desktop/folders/posts", frame: "posts-folder",
                   width: "40rem", height: "30rem", kind: "explorer" }, window.to_params)
  end

  test "a window without a frame leaves it out, for an iframe" do
    window = Desktop::Window.new(name: "about", title: "About", menu: "website", src: "/about",
                                 width: "20rem", height: "10rem")

    assert_not window.to_params.key?(:frame)
  end

  test "kind is optional" do
    window = Desktop::Window.new(name: "notes", title: "Notes", menu: "accessories", src: "/notes", frame: "notes",
                                 width: "20rem", height: "10rem")

    assert_not window.to_params.key?(:kind)
  end
end
