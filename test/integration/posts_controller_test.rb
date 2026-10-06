require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
  end

  test "should get index" do
    get posts_url

    assert_response :success
  end

  test "should show post" do
    get post_url(@post)

    assert_response :success
    assert_select ".site-nav a[aria-current]", count: 1, text: "Posts"
  end

  test "should show tag" do
    tag = Tag.take
    get tag_posts_path(tag.name)

    assert_response :success
    assert_select "h1", "Posts tagged #{tag.name}"
  end
end
