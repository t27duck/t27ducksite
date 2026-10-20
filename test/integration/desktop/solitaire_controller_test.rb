require "test_helper"

class Desktop::SolitaireControllerTest < ActionDispatch::IntegrationTest
  test "renders an empty board for the game to deal" do
    get desktop_solitaire_url

    assert_select "turbo-frame#solitaire [data-controller=solitaire]" do
      assert_select "[data-pile^=foundation]", count: 4
      assert_select "[data-pile^=tableau]:empty", count: 7
    end
  end
end
