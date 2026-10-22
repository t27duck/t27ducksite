require "application_system_test_case"

class SolitaireTest < ApplicationSystemTestCase
  setup do
    visit root_path
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

  test "the game stays open as you navigate the site" do
    within("#solitaire-window") { find(".pile[data-pile=stock]").click }
    navigate_away

    within("#solitaire-window[open]") { assert_selector "[data-pile=waste] .card", count: 1 }
  end

  test "the window stays where you put it as you navigate the site" do
    move_window_by(-100, 50)
    position = window_position
    navigate_away

    assert_equal position, window_position
  end

  test "dragging the title bar moves the window" do
    before = window_position
    move_window_by(-100, 50)

    assert_equal [before[0] - 100, before[1] + 50], window_position
  end

  test "the window is resizable" do
    assert_equal "both", evaluate_script("getComputedStyle(document.getElementById('solitaire-window')).resize")
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

    assert_no_selector "#solitaire-window[open]"
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
    within("#solitaire-window > .titlebar") { click_on "Close" }

    assert_no_selector "#solitaire-window[open]"
    open_solitaire

    within("#solitaire-window") { assert_no_selector "[data-pile=waste] .card" }
  end

  private ######################################################################

  def open_solitaire
    5.times { find(".site-footer span").click }

    assert_selector "#solitaire-window[open] [data-pile^=tableau] .card", count: 28 # dealt, so the controller is up
  end

  def navigate_away
    click_on "Posts"

    assert_current_path posts_path
    click_on "Projects"

    assert_current_path projects_path
  end

  def move_window_by(right, down)
    titlebar = find("#solitaire-window > .titlebar h2").native
    page.driver.browser.action.move_to(titlebar).click_and_hold.move_by(right, down).release.perform
  end

  def window_position
    evaluate_script("(w => [w.offsetLeft, w.offsetTop])(document.getElementById('solitaire-window'))")
  end

  # Every card on the foundations but the king of clubs, which waits on the tableau.
  def one_move_from_winning
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
