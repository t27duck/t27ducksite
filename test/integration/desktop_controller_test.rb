require "test_helper"

class DesktopControllerTest < ActionDispatch::IntegrationTest
  test "should show the desktop" do
    get desktop_url

    assert_response :success
  end

  # Fixtures have three published posts, plus a published talk and drafts that must not appear.
  test "Documents lists only published posts, newest first" do
    get desktop_url

    assert_select "#documents-menu a", count: 3
    assert_select "#documents-menu li:last-child a", text: "Oldest Post"
  end

  test "folder windows load their files lazily" do
    get desktop_url

    assert_select "#posts-window turbo-frame[loading=lazy][src=?]", desktop_folder_path("posts")
  end
end
