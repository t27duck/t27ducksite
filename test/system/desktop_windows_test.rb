require "application_system_test_case"

class DesktopWindowsTest < ApplicationSystemTestCase
  test "folders open side by side and close independently" do
    visit desktop_path

    find_button("Posts").double_click
    find_button("Talks").double_click

    assert_selector "dialog[open]", count: 2

    within("#talks-window") { click_on "Close" }

    assert_selector "dialog[open]", count: 1
    assert_link "Oldest Post"
  end

  test "explorer windows open at the same size whatever they hold" do
    visit desktop_path

    find_button("Posts").double_click
    find_button("Talks").double_click

    assert_link "Talk 1"

    posts = find_by_id("posts-window").rect
    talks = find_by_id("talks-window").rect

    assert_equal [posts.width, posts.height], [talks.width, talks.height]
  end

  test "dragging the title bar moves the window" do
    visit desktop_path
    find_button("Posts").double_click
    window = find_by_id("posts-window")
    start = window.rect

    drag_title_bar(window, 200, 100)

    assert_equal [start.x + 200, start.y + 100], [window.rect.x, window.rect.y]
  end

  test "a full folder stops growing and scrolls its icons" do
    create_filler_posts
    visit desktop_path

    find_button("Posts").double_click

    assert_link "Filler post 0"
    body = find("#posts-window .window-body")

    assert_operator body.evaluate_script("this.scrollHeight"), :>, body.evaluate_script("this.clientHeight")
  end

  test "double-clicking a file opens its page" do
    visit desktop_path
    find_button("Talks").double_click

    find_link("Talk 1").double_click

    assert_current_path post_path(posts(:three))
  end

  test "closing a window resets its position and contents" do
    visit desktop_path
    find_button("Talks").double_click
    window = find_by_id("talks-window")
    start = window.rect
    drag_title_bar(window, 200, 100)
    Post.create!(title: "Brand new talk", kind: "talk", video_url: "https://www.youtube.com/watch?v=bbbbbbbbbbb",
                 published_at: Time.current)

    within(window) { click_on "Close" }
    find_button("Talks").double_click

    assert_link "Brand new talk"
    assert_equal [start.x, start.y], [window.rect.x, window.rect.y]
  end

  test "a reopened window is scrolled back to the top" do
    create_filler_posts
    visit desktop_path
    find_button("Posts").double_click

    assert_link "Filler post 0"
    body = find("#posts-window .window-body")
    body.execute_script("this.scrollTop = 200")

    within("#posts-window") { click_on "Close" }
    find_button("Posts").double_click

    assert_equal 0, body.evaluate_script("this.scrollTop")
  end

  private ######################################################################

  # Enough posts to overflow an Explorer window.
  def create_filler_posts
    30.times do |i|
      Post.create!(title: "Filler post #{i}", content: "Filler", kind: "post", published_at: Time.current)
    end
  end

  def drag_title_bar(window, right, down)
    title = window.find(".titlebar h2").native
    page.driver.browser.action.click_and_hold(title).move_by(right, down).release.perform
  end
end
