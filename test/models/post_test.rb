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

  test "#talk? is true only for the talk kind" do
    assert_predicate posts(:three), :talk?
    assert_not_predicate @post, :talk?
  end

  test "#youtube_id extracts the id from the video url" do
    assert_equal "dQw4w9WgXcQ", posts(:three).youtube_id
    assert_nil @post.youtube_id
  end

  test "content is required for posts but not talks" do
    @post.content = ""

    assert_not_predicate @post, :valid?
    assert_includes @post.errors.attribute_names, :content

    talk = posts(:three)
    talk.content = ""

    assert_predicate talk, :valid?
  end

  test "video_url is required for talks but not posts" do
    talk = posts(:three)
    talk.video_url = nil

    assert_not_predicate talk, :valid?
    assert_includes talk.errors.attribute_names, :video_url

    assert_predicate @post, :valid?
  end

  test "video_url must be a youtube url" do
    talk = posts(:three)

    [
      "https://vimeo.com/12345",
      # Unanchored matching would let these through and put the value straight
      # into the Direct Link href.
      "javascript:alert(1)#https://www.youtube.com/watch?v=dQw4w9WgXcQ",
      "https://evil.example.com/?x=https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    ].each do |url|
      talk.video_url = url

      assert_not_predicate talk, :valid?, "#{url} should be rejected"
      assert_includes talk.errors.attribute_names, :video_url
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
