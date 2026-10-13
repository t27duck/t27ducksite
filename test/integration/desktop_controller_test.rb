require "test_helper"

class DesktopControllerTest < ActionDispatch::IntegrationTest
  test "should show the desktop" do
    get desktop_url

    assert_response :success
  end
end
