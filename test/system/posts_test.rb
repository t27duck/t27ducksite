# frozen_string_literal: true

require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  setup do
    @post = posts(:one)
  end

  test "should get index" do
    visit posts_url

    assert_text "All Posts"
  end

  test "should show post" do
    visit post_url(@post)

    assert_text @post.title
    assert_text @post.summary
  end

  test "should show tag" do
    tag = Tag.take

    assert_predicate tag.posts.count, :positive?

    visit tag_posts_path(tag.name)

    tag.posts.each do |post|
      assert_text post.title
      assert_text post.summary
    end
  end
end
