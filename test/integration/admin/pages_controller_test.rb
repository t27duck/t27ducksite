# frozen_string_literal: true

require "test_helper"

class Admin::PagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @page = pages(:about)
    login_user
  end

  test "should get index" do
    get admin_pages_url

    assert_response :success
  end

  test "should get edit" do
    get edit_admin_page_url(@page)

    assert_response :success
  end

  test "should update page" do
    patch admin_page_url(@page), params: {
      page: { title: @page.title, content: @page.content }
    }

    assert_redirected_to admin_pages_path
  end

  test "should not update page if not valid" do
    patch admin_page_url(@page), params: {
      page: { content: "" }
    }

    assert_response :success
  end

  test "should display preview" do
    post preview_admin_pages_path, params: { content: @page.content }

    assert_response :success
  end
end
