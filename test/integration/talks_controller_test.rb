require "test_helper"

class TalksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get talks_url

    assert_response :success
  end

  test "index renders the youtube embed" do
    get talks_url

    assert_select "div.video iframe[src=?]", "https://www.youtube.com/embed/dQw4w9WgXcQ?rel=0"
    assert_select "a[href=?]", "https://www.youtube.com/watch?v=dQw4w9WgXcQ", text: "Direct Link"
  end

  # Talks carry no rich text. If the talk? branch in posts/_post is ever dropped,
  # this catches it before ten talks turn into ten extra queries.
  test "index does not load rich text" do
    assert_no_queries_match(/action_text_rich_texts/) { get talks_url }
  end
end
