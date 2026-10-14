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

  test "projects folder lists every project" do
    get desktop_folder_url("projects")

    assert_select "turbo-frame#projects-folder .desktop-icon", count: Project.count
  end

  test "unknown folders are not found" do
    get "/desktop/folders/admin"

    assert_response :not_found
  end
end
