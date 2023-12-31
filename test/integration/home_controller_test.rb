# frozen_string_literal: true

require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should show home page" do
    get root_url

    assert_response :success
  end
end
