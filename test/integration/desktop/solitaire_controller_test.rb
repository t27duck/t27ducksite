require "test_helper"

class Desktop::SolitaireControllerTest < ActionDispatch::IntegrationTest
  test "has a File menu with New Game and Quit" do
    get desktop_solitaire_url

    assert_select "#solitaire-file-menu button", text: "New Game"
    assert_select "#solitaire-file-menu form[method=dialog] button", text: "Quit"
  end

  test "has a hidden won dialog in place of the old header" do
    get desktop_solitaire_url

    assert_select "dialog.won-dialog:not([open])", text: /You win!/
    assert_select ".solitaire header", count: 0
  end

  test "renders an empty board for the game to deal" do
    get desktop_solitaire_url

    assert_select "turbo-frame#solitaire [data-controller=solitaire]" do
      assert_select "[data-pile^=foundation]", count: 4
      assert_select "[data-pile^=tableau]:empty", count: 7
    end
  end
end
