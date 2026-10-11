require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should show home page" do
    get root_url

    assert_response :success
    assert_select ".site-nav a[aria-current]", count: 0
    assert_select ".more a[href=?]", projects_path, text: "All projects"
  end
end
