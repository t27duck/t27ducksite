# frozen_string_literal: true

require "test_helper"

class PostTest < ActiveSupport::TestCase
  def setup
    @post = posts(:one)
  end

  test "#publish is true if published_at is set" do
    @post.published_at = nil

    assert_not @post.publish

    @post.published_at = Time.now.utc

    assert @post.publish
  end

  test "#publish= sets published_at with a truthy value" do
    {
      "true" => true,
      true => true,
      "1" => true,
      1 => true,
      "false" => false,
      false => false,
      "0" => false,
      0 => false
    }.each do |input, expected|
      @post.publish = input

      assert_equal @post.published_at.present?, expected
    end
  end

  test "tags_input= sets or creates tags for the post" do
    post = Post.new
    assert_difference "Tag.count", 2 do
      post.tags_input = "tag1, tag 2,,one, ,two"
    end

    tag_names = post.tags.map(&:name)

    assert_includes tag_names, "tag1", "Post missing tag1 tag"
    assert_includes tag_names, "tag-2", "Post missing tag-2 tag"
  end
end
