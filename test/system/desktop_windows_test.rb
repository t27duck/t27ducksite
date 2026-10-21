require "application_system_test_case"

class DesktopWindowsTest < ApplicationSystemTestCase
  test "folders open side by side and close independently" do
    visit desktop_path

    find_button("Posts").double_click
    find_button("Talks").double_click

    assert_selector "dialog[open]", count: 2

    within("#talks-window") { click_on "Close" }

    assert_selector "dialog[open]", count: 1
    assert_button "Oldest Post"
  end

  test "explorer windows open at the same size whatever they hold" do
    visit desktop_path

    find_button("Posts").double_click
    find_button("Talks").double_click

    assert_button "Talk 1"

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

    assert_button "Filler post 0"
    body = find("#posts-window .window-body")

    assert_operator body.evaluate_script("this.scrollHeight"), :>, body.evaluate_script("this.clientHeight")
  end

  test "double-clicking a file opens it in a program without leaving the desktop" do
    visit desktop_path
    find_button("Posts").double_click

    find_button("Oldest Post").double_click

    assert_selector "#internet_explorer-window h1", text: "Oldest Post"
    assert_current_path desktop_path
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

    assert_button "Brand new talk"
    assert_equal [start.x, start.y], [window.rect.x, window.rect.y]
  end

  test "a reopened window is scrolled back to the top" do
    create_filler_posts
    visit desktop_path
    find_button("Posts").double_click

    assert_button "Filler post 0"
    body = find("#posts-window .window-body")
    body.execute_script("this.scrollTop = 200")

    within("#posts-window") { click_on "Close" }
    find_button("Posts").double_click

    assert_equal 0, find("#posts-window .window-body").evaluate_script("this.scrollTop")
  end

  test "a window without a frame loads its page in an iframe" do
    visit desktop_path
    add_opener("About", id: "about-window", title: "About", src: about_path, width: "30rem", height: "20rem")

    click_on "About"

    within("#about-window") do
      within_frame(find("iframe[title=About]")) { assert_selector "h1", text: "MyString" }
    end
  end

  private ######################################################################

  # A button that opens a window from params alone, without config/desktop.yml.
  def add_opener(label, **params)
    execute_script(<<~JS, label, params.to_json)
      const button = document.createElement("button")
      button.textContent = arguments[0]
      button.dataset.action = "desktop#open"
      button.dataset.desktopWindowParam = arguments[1]
      document.querySelector("main").append(button)
    JS
  end

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
