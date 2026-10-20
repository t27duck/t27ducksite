require "test_helper"

class Desktop::FoldersControllerTest < ActionDispatch::IntegrationTest
  test "posts folder lists published posts" do
    get desktop_folder_url("posts")

    assert_select "turbo-frame#posts-folder .desktop-icon", count: 3
  end

  test "talks folder lists published talks" do
    get desktop_folder_url("talks")

    assert_select "turbo-frame#talks-folder .desktop-icon", text: "Talk 1", count: 1
    assert_select ".desktop-icon", text: "Draft Talk", count: 0
  end

  test "talks play in the Media Player" do
    get desktop_folder_url("talks")

    button = css_select("button.desktop-icon[data-action~='desktop#load']").sole
    params = JSON.parse(button["data-desktop-window-param"])

    assert_equal ["media_player-window", desktop_media_player_path(talk: posts(:three))], params.values_at("id", "src")
  end

  test "projects folder lists every project" do
    get desktop_folder_url("projects")

    assert_select "turbo-frame#projects-folder .desktop-icon", count: Project.count
  end

  test "each configured window's src renders its frame" do
    Desktop::Window.configured.select(&:frame).each do |window|
      get window.src

      assert_select "turbo-frame##{window.frame}", { count: 1 }, "#{window.name} window"
    end
  end

  test "unknown folders are not found" do
    get "/desktop/folders/admin"

    assert_response :not_found
  end
end
