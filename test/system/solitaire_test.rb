require "application_system_test_case"

class SolitaireTest < ApplicationSystemTestCase
  setup do
    visit desktop_path
    click_on "Start"
    click_on "Programs"
    click_on "Accessories"
    click_on "Solitaire"
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

  test "closing the window throws the game away" do
    within("#solitaire-window") do
      find(".pile[data-pile=stock]").click
      click_on "Close"
    end
    click_on "Start"
    click_on "Programs"
    click_on "Accessories"
    click_on "Solitaire"

    within("#solitaire-window") { assert_no_selector "[data-pile=waste] .card" }
  end
end
