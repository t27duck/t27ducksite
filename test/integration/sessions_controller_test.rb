require "test_helper"

class Admin::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_session_url

    assert_response :success
  end

  test "create should sign in edirect" do
    assert_difference -> { users(:one).sessions.count } do
      post session_url, params: { password: TEST_ENV_PASSWORD }
    end

    assert_redirected_to admin_url
    assert cookies[:session_id]
  end

  test "create returns to the page that required sign in" do
    get admin_projects_url
    post session_url, params: { password: TEST_ENV_PASSWORD }

    assert_redirected_to admin_projects_url
  end

  test "create should not login if password is wrong" do
    assert_no_difference -> { Session.count } do
      post session_url, params: { password: "xxx" }
    end

    assert_response :unprocessable_content
    assert_nil cookies[:session_id]
  end

  test "create should not login without a password" do
    post session_url

    assert_response :unprocessable_content
  end

  test "create is rate limited after repeated attempts" do
    10.times { post session_url, params: { password: "xxx" } }
    post session_url, params: { password: TEST_ENV_PASSWORD }

    assert_redirected_to new_session_url
    assert_equal "Too many sign in attempts. Try again later.", flash[:alert]
  end

  test "destroy logs user out" do
    login_user

    assert_difference -> { Session.count }, -1 do
      delete session_url
    end

    assert_redirected_to root_url
    assert_empty cookies[:session_id]
  end

  test "destroy revokes access to admin" do
    login_user
    delete session_url
    get admin_posts_url

    assert_redirected_to new_session_url
  end
end
