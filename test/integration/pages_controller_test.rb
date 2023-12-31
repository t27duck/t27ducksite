# frozen_string_literal: true

require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should show about page" do
    get "/about"

    assert_response :success
  end
end
