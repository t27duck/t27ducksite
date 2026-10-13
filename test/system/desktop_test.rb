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

  test "start menu links go to their pages" do
    visit desktop_path
    click_on "Start"

    click_on "Programs"
    within("#programs-menu") { click_on "Projects" }

    assert_current_path projects_path
  end
end
