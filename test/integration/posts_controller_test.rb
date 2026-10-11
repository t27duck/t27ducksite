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

  test "show links each tag to its tag page" do
    get post_url(@post)

    assert_select "p.tags a[href=?]", tag_path(tags(:one)), text: "one"
  end

  test "show 404s for an unpublished post when signed out" do
    get post_url(posts(:unpublished_post))

    assert_response :not_found
  end

  test "show previews an unpublished post when signed in" do
    login_user
    get post_url(posts(:unpublished_post))

    assert_response :success
    assert_select ".post-meta", "Not published"
  end
end
