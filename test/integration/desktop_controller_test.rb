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

  test "desktop icons open the windows configured with shortcuts" do
    get desktop_url

    params = Desktop::Window.configured.select(&:shortcut).map { |window| window.to_params.to_json }

    assert_equal(["Posts", "Talks", "Projects"], css_select("main button.desktop-icon").map { it.text.strip })
    assert_equal params, css_select("main button.desktop-icon").pluck("data-desktop-window-param")
  end

  test "Programs lists each window in its configured submenu" do
    get desktop_url

    assert_select "#accessories-menu button", text: "Solitaire", count: 1
    website = css_select("#website-menu li").map { it.text.strip }

    assert_equal ["Posts", "Talks", "Projects", "About", "Resume"], website
    assert_select "#programs-menu [data-desktop-window-param]", count: Desktop::Window.configured.size
  end

  test "windows are built on demand, not rendered up front" do
    get desktop_url

    assert_select "main dialog", count: 0
    assert_select "template[data-desktop-target=template]", count: 1
  end
end
