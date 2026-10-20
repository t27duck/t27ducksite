require "test_helper"

class Desktop::MediaPlayerControllerTest < ActionDispatch::IntegrationTest
  test "with no talk there's no media" do
    get desktop_media_player_url

    assert_select "turbo-frame#media-player .screen", text: "No media"
    assert_select "iframe", count: 0
  end

  test "plays a talk with its title, date, and YouTube link" do
    get desktop_media_player_url(talk: posts(:three))

    assert_select "turbo-frame#media-player .screen iframe[src=?]", "https://www.youtube.com/embed/dQw4w9WgXcQ?rel=0"
    assert_select ".status", text: /Talk 1\s+June 1, 2016/
    assert_select ".status a[href=?][target=_blank]", posts(:three).video_url
  end

  test "File > Open browses the talks in a modal dialog" do
    get desktop_media_player_url

    assert_select "#media-player-file-menu button[command=show-modal][commandfor=media-player-open]", text: "Open…"
    assert_select "#media-player-file-menu form[method=dialog] button", text: "Exit"
    assert_select "dialog#media-player-open turbo-frame#media-player-open-files[loading=lazy][src=?]",
                  desktop_media_player_files_path
  end

  test "the Open dialog lists published talks that load into the player" do
    get desktop_media_player_files_url

    assert_select "turbo-frame#media-player-open-files a.desktop-icon", count: 1 do |links|
      assert_equal [desktop_media_player_path(talk: posts(:three)), "media-player"],
                   [links.first["href"], links.first["data-turbo-frame"]]
    end
  end

  test "drafts and posts aren't playable" do
    get desktop_media_player_url(talk: posts(:unpublished_talk))

    assert_response :not_found

    get desktop_media_player_url(talk: posts(:one))

    assert_response :not_found
  end
end
