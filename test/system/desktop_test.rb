require "application_system_test_case"

class DesktopTest < ApplicationSystemTestCase
  test "Start opens and closes the start menu" do
    visit desktop_path

    assert_no_button "Programs"

    click_on "Start"

    assert_button "Programs"

    click_on "Start"

    assert_no_button "Programs"
  end

  test "hovering an item opens its submenu and closes the other" do
    visit desktop_path
    click_on "Start"

    find_button("Programs").hover

    assert_link "Resume"

    find_button("Socials").hover

    assert_link "GitHub"
    assert_no_link "Resume"
  end

  test "clicking an item opens its submenu" do
    visit desktop_path
    click_on "Start"

    click_on "Documents"

    assert_link "Oldest Post"
  end

  test "a single click selects a desktop icon without opening it" do
    visit desktop_path

    click_on "Posts"

    assert_no_selector "dialog[open]"

    click_on "t27duck.com"

    assert_current_path desktop_path
  end

  test "double-clicking a desktop link opens it" do
    visit desktop_path

    find_link("t27duck.com").double_click

    assert_current_path root_path
  end

  test "folders open side by side and close independently" do
    visit desktop_path

    find_button("Posts").double_click
    find_button("Talks").double_click

    assert_selector "dialog[open]", count: 2

    within("#talks-window") { click_on "Close" }

    assert_selector "dialog[open]", count: 1
    assert_link "Oldest Post"
  end

  test "Programs opens a folder window and closes the start menu" do
    visit desktop_path
    click_on "Start"

    click_on "Programs"
    within("#programs-menu") { click_on "Projects" }

    assert_selector "#projects-window[open]"
    assert_no_button "Programs"
  end

  test "dragging the title bar moves the window" do
    visit desktop_path
    find_button("Posts").double_click
    window = find_by_id("posts-window")
    start = window.rect

    title = window.find(".titlebar h2").native
    page.driver.browser.action.click_and_hold(title).move_by(200, 100).release.perform

    assert_equal [start.x + 200, start.y + 100], [window.rect.x, window.rect.y]
  end

  test "a full folder stops growing and scrolls its icons" do
    30.times do |i|
      Post.create!(title: "Filler post #{i}", content: "Filler", kind: "post", published_at: Time.current)
    end
    visit desktop_path

    find_button("Posts").double_click
    body = find("#posts-window .window-body")

    assert_operator body.evaluate_script("this.scrollHeight"), :>, body.evaluate_script("this.clientHeight")
  end
end
