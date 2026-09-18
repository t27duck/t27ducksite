require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should show about page" do
    get "/about"

    assert_response :success
  end

  test "renders rich text content in a lexxy wrapper" do
    get "/about"

    assert_select "div.lexxy-content[data-controller=?]", "syntax-highlight"
    assert_select "div.lexxy-content p", text: "MyText"
  end
end
