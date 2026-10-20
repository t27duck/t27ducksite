require "application_system_test_case"

class SolitaireTest < ApplicationSystemTestCase
  setup do
    visit desktop_path
    open_solitaire
  end

  test "deals a game of Klondike" do
    within("#solitaire-window") do
      assert_selector "[data-pile^=tableau] .card", count: 28
      assert_selector "[data-pile^=tableau] .card:not(.down)", count: 7
      assert_no_selector "[data-pile=waste] .card"
    end
  end

  test "clicking the stock turns a card onto the waste" do
    within("#solitaire-window") do
      find(".pile[data-pile=stock]").click

      assert_selector "[data-pile=waste] .card:not(.down)", count: 1
    end
  end

  test "File > New Game deals again and closes the menu" do
    within("#solitaire-window") do
      find(".pile[data-pile=stock]").click
      click_on "File"
      click_on "New Game"

      assert_no_selector "[data-pile=waste] .card"
      assert_no_button "Quit"
    end
  end

  test "File > Quit closes the window" do
    within("#solitaire-window") { click_on "File" }
    click_on "Quit"

    assert_no_selector "#solitaire-window"
  end

  test "winning pops up a dialog that deals a new game" do
    one_move_from_winning
    find("#solitaire-window [data-pile=tableau-0] .card").double_click

    within("dialog.won-dialog[open]") do
      assert_text "You win!"
      click_on "New Game"
    end

    assert_no_selector "dialog.won-dialog[open]"
    assert_selector "#solitaire-window [data-pile^=tableau] .card", count: 28
  end

  test "closing the window throws the game away" do
    within("#solitaire-window") do
      find(".pile[data-pile=stock]").click
      click_on "Close"
    end
    open_solitaire

    within("#solitaire-window") { assert_no_selector "[data-pile=waste] .card" }
  end

  private ######################################################################

  def open_solitaire
    click_on "Start"
    click_on "Programs"
    click_on "Accessories"
    click_on "Solitaire"
  end

  # Every card on the foundations but the king of clubs, which waits on the tableau.
  def one_move_from_winning
    assert_selector "#solitaire-window [data-pile^=tableau] .card", count: 28 # dealt, so the controller is up
    execute_script(<<~JS)
      const element = document.querySelector("#solitaire-window [data-controller=solitaire]")
      const game = Stimulus.getControllerForElementAndIdentifier(element, "solitaire")
      game.piles = { stock: [], waste: [] }
      ;["♠", "♥", "♦", "♣"].forEach((suit, i) => {
        game.piles[`foundation-${i}`] = Array.from({ length: 13 }, (_, rank) => ({ suit, rank: rank + 1, up: true }))
      })
      for (let i = 0; i < 7; i++) game.piles[`tableau-${i}`] = []
      game.piles["tableau-0"].push(game.piles["foundation-3"].pop())
      game.render()
    JS
  end
end
