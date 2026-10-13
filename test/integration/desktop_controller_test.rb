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

  test "folder windows list only published files" do
    get desktop_url

    assert_select "#posts-window .desktop-icon", count: 3
    assert_select "#talks-window .desktop-icon", text: "Talk 1", count: 1
    assert_select "#projects-window .desktop-icon", count: Project.count
  end
end
