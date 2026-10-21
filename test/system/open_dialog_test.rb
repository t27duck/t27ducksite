require "application_system_test_case"

# The Open dialog, as the Media Player uses it.
class OpenDialogTest < ApplicationSystemTestCase
  setup do
    visit desktop_path
    click_on "Start"
    click_on "Programs"
    click_on "Accessories"
    click_on "Media Player"
    within("#media_player-window") { click_on "File" }
    click_on "Open…"
  end

  test "File > Open shows the dialog and closes the menu" do
    assert_selector "dialog#media-player-open[open]"
    assert_no_button "Exit"
    assert_button "Open", disabled: true
  end

  test "double-clicking a file opens it" do
    find_link("Talk 1").double_click

    assert_no_selector "dialog#media-player-open[open]"
    assert_selector "#media_player-window .status", text: "Talk 1"
  end

  test "clicking a file selects it for the Open button" do
    find_link("Talk 1").click

    assert_field "File name", with: "Talk 1"
    assert_selector "#media_player-window .screen", text: "No media"

    click_on "Open"

    assert_selector "#media_player-window .status", text: "Talk 1"
  end

  test "Cancel closes the dialog and clears the selection" do
    find_link("Talk 1").click
    click_on "Cancel"

    assert_no_selector "dialog#media-player-open[open]"
    assert_selector "#media_player-window .screen", text: "No media"

    within("#media_player-window") { click_on "File" }
    click_on "Open…"

    assert_field "File name", with: ""
  end
end
