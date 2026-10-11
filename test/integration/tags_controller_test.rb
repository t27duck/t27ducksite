require "test_helper"

class TagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tag = tags(:one)
  end

  test "should show tag" do
    get tag_path(@tag)

    assert_response :success
    assert_select "h1", "Posts tagged #{@tag.name}"
    assert_select "h2.entry-title", text: posts(:one).title
  end

  test "show highlights the Posts nav item" do
    get tag_path(@tag)

    assert_select ".site-nav a[aria-current]", count: 1, text: "Posts"
  end

  test "show finds the tag from an unparameterized name" do
    get tag_path(@tag.name.upcase)

    assert_response :success
  end

  test "show 404s for an unknown tag" do
    get tag_path("no-such-tag")

    assert_response :not_found
  end
end
