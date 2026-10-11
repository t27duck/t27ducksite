require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "formatted_title keeps inline markup" do
    title = "Config for <strike>Fun and</strike> Profit"

    assert_equal title, formatted_title(title)
  end

  test "formatted_title strips scripts and attributes" do
    assert_equal "Hi alert(1)<em>there</em>", formatted_title(%(Hi <script>alert(1)</script><em onclick="x">there</em>))
  end
end
