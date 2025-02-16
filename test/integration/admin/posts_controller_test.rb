# frozen_string_literal: true

require "test_helper"

class Admin::PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
    login_user
  end

  test "should get index" do
    get admin_posts_url

    assert_response :success
  end

  test "should get new" do
    get new_admin_post_url

    assert_response :success
  end

  test "should create post" do
    assert_difference("Post.count") do
      post admin_posts_url, params: {
        post: {
          content: @post.content, kind: "post", summary: @post.summary,
          published_at: @post.published_at, title: @post.title
        }
      }
    end

    assert_redirected_to admin_posts_path
  end

  test "should not create post if not valid" do
    assert_no_difference("Post.count") do
      post admin_posts_url, params: {
        post: {
          content: @post.content, kind: "post", summary: @post.summary, published_at: @post.published_at, title: ""
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_admin_post_url(@post)

    assert_response :success
  end

  test "should update post" do
    patch admin_post_url(@post), params: {
      post: { content: @post.content, published_at: @post.published_at, title: @post.title }
    }

    assert_redirected_to admin_posts_path
  end

  test "should not update post if not valid" do
    patch admin_post_url(@post), params: {
      post: { content: @post.content, published_at: @post.published_at, title: "" }
    }

    assert_response :unprocessable_entity
  end

  test "should destroy post" do
    assert_difference("Post.count", -1) do
      delete admin_post_url(@post)
    end

    assert_redirected_to admin_posts_path
  end
end
