require "application_system_test_case"

class MediaPlayerTest < ApplicationSystemTestCase
  test "double-clicking a talk plays it in the Media Player" do
    visit desktop_path
    find_button("Talks").double_click

    find_button("Talk 1").double_click

    within("#media_player-window") do
      assert_selector "iframe[src*='youtube.com/embed/dQw4w9WgXcQ']"
      assert_selector ".status", text: "Talk 1"
    end
  end

  test "another talk replaces the one playing, in the same window" do
    Post.create!(title: "Second talk", kind: "talk", video_url: "https://www.youtube.com/watch?v=bbbbbbbbbbb",
                 published_at: Time.current)
    visit desktop_path
    find_button("Talks").double_click
    find_button("Talk 1").double_click

    assert_selector "#media_player-window .status", text: "Talk 1"

    find("#talks-window .titlebar h2").click # the player opened over the folder
    find_button("Second talk").double_click

    assert_selector "#media_player-window .status", text: "Second talk"
    assert_selector "#media_player-window", count: 1
  end

  test "Accessories opens an empty player" do
    visit desktop_path

    open_media_player_from_start_menu

    assert_selector "#media_player-window .screen", text: "No media"
  end

  test "the Start menu brings an open player forward without stopping its talk" do
    visit desktop_path
    find_button("Talks").double_click
    find_button("Talk 1").double_click

    assert_selector "#media_player-window .status", text: "Talk 1"

    open_media_player_from_start_menu

    assert_selector "#media_player-window .status", text: "Talk 1"
  end

  private ######################################################################

  def open_media_player_from_start_menu
    click_on "Start"
    click_on "Programs"
    click_on "Accessories"
    click_on "Media Player"
  end
end
