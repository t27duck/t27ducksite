require "application_system_test_case"

class InternetExplorerTest < ApplicationSystemTestCase
  test "double-clicking a post browses to it in Internet Explorer" do
    visit desktop_path
    find_button("Posts").double_click

    find_button("Post 1").double_click

    within("#internet_explorer-window") do
      assert_selector ".page h1", text: "Post 1"
      assert_field with: post_url(posts(:one), host: Capybara.current_session.server.host,
                                               port: Capybara.current_session.server.port)
    end
    assert_current_path desktop_path
  end

  test "a wide code block scrolls inside the page instead of widening it past the window" do
    posts(:one).update!(content: "<pre data-language=\"ruby\">#{'x' * 500}</pre>")
    visit desktop_path
    find_button("Posts").double_click
    find_button("Post 1").double_click

    body = find("#internet_explorer-window > .window-body")

    assert_selector "#internet_explorer-window pre"
    assert_equal body.evaluate_script("this.clientWidth"), body.evaluate_script("this.scrollWidth")
  end

  test "dragging the bottom-right corner resizes the browser" do
    visit desktop_path
    find_button("Posts").double_click
    find_button("Post 1").double_click
    browser = find_by_id("internet_explorer-window")
    width, height = browser.evaluate_script("[this.offsetWidth, this.offsetHeight]")

    drag_corner(browser, -100, -80)

    assert_equal [width - 100, height - 80], browser.evaluate_script("[this.offsetWidth, this.offsetHeight]")
  end

  test "only the browser is resizable" do
    visit desktop_path
    find_button("Posts").double_click
    find_button("Post 1").double_click

    assert_equal "both", find_by_id("internet_explorer-window").evaluate_script("getComputedStyle(this).resize")
    assert_equal "none", find_by_id("posts-window").evaluate_script("getComputedStyle(this).resize")
  end

  test "another post replaces the page, in the same window" do
    visit desktop_path
    find_button("Posts").double_click
    find_button("Post 1").double_click

    assert_selector "#internet_explorer-window h1", text: "Post 1"

    find("#posts-window .titlebar h2").click # the browser opened over the folder
    find_button("Post 2").double_click

    assert_selector "#internet_explorer-window h1", text: "Post 2"
    assert_selector "#internet_explorer-window", count: 1
  end

  test "projects browse in the same window as posts" do
    visit desktop_path
    find_button("Posts").double_click
    find_button("Post 1").double_click

    assert_selector "#internet_explorer-window h1", text: "Post 1"

    find_button("Projects").double_click
    find_button("Oldest Project").double_click

    assert_selector "#internet_explorer-window h1", text: "Oldest Project"
    assert_selector "#internet_explorer-window", count: 1
  end

  test "Start > Documents opens a post" do
    visit desktop_path
    click_on "Start"
    click_on "Documents"

    click_on "Oldest Post"

    assert_selector "#internet_explorer-window h1", text: "Oldest Post"
    assert_no_selector "#start-menu:popover-open"
  end

  test "Accessories opens a blank browser" do
    visit desktop_path
    click_on "Start"
    click_on "Programs"
    click_on "Accessories"

    click_on "Internet Explorer"

    assert_field with: "about:blank"
  end

  test "File > Close closes the browser" do
    visit desktop_path
    click_on "Start"
    click_on "Programs"
    click_on "Accessories"
    click_on "Internet Explorer"

    within("#internet_explorer-window") { click_on "File" }
    within("#internet-explorer-file-menu") { click_on "Close" }

    assert_no_selector "#internet_explorer-window"
  end

  test "Open full page leaves the desktop for the post" do
    visit desktop_path
    find_button("Posts").double_click
    find_button("Post 1").double_click

    within("#internet_explorer-window") { click_on "Open full page" }

    assert_current_path post_path(posts(:one))
  end

  private ######################################################################

  # Selenium offsets from the element's centre; the grip is just inside the
  # bottom-right corner.
  def drag_corner(window, right, down)
    width, height = window.evaluate_script("[this.offsetWidth, this.offsetHeight]")
    page.driver.browser.action.move_to(window.native, (width / 2) - 4, (height / 2) - 4)
        .click_and_hold.move_by(right, down).release.perform
  end
end
