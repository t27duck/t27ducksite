require "test_helper"

class Admin::AuthenticationTest < ActionDispatch::IntegrationTest
  test "admin pages redirect to sign in when signed out" do
    [admin_pages_url, admin_posts_url, admin_projects_url].each do |url|
      get url

      assert_redirected_to new_session_url
    end
  end
end
