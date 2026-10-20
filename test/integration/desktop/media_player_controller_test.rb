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

  test "drafts and posts aren't playable" do
    get desktop_media_player_url(talk: posts(:unpublished_talk))

    assert_response :not_found

    get desktop_media_player_url(talk: posts(:one))

    assert_response :not_found
  end
end
