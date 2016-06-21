require 'test_helper'

class Admin::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
  end

  test 'should get new' do
    get new_session_url
    assert_response :success
  end

  test 'new should redirect to root if already logged in' do
    login_user
    get new_session_url
    assert_redirected_to root_url
  end

  test 'create should set token and redirect' do
    post session_url, params: {password: TEST_ENV_PASSWORD}
    refute cookies['token'].blank?
    assert_redirected_to root_url
  end

  test 'create should not login if password is wrong' do
    post session_url, params: {password: 'xxx'}
    assert cookies['token'].blank?
    assert_response :success
  end

  test 'create redirects if already logged in' do
    login_user
    current_token = cookies['token']
    post session_url, params: {password: TEST_ENV_PASSWORD}
    assert_equal current_token, cookies['token']
    assert_redirected_to root_url
  end

  test 'destroy logs user out' do
    login_user
    delete session_url
    assert_redirected_to root_url
    assert cookies['token'].blank?
  end
end
