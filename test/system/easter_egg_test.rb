require "application_system_test_case"

class EasterEggTest < ApplicationSystemTestCase
  KONAMI = [:up, :up, :down, :down, :left, :right, :left, :right, "b", "a"].freeze

  test "the Konami code opens Solitaire over the page" do
    visit post_path(posts(:one))

    press(*KONAMI)

    assert_selector "#solitaire-window[open] [data-pile^=tableau] .card", count: 28
    assert_selector "h1", text: "Post 1"
  end

  test "five taps on the copyright open Solitaire" do
    visit root_path

    5.times { find(".site-footer span").click }

    assert_selector "#solitaire-window[open]"
  end

  test "a wrong key or too few taps does nothing" do
    visit post_path(posts(:one))

    press(:up, :up, :down, :down, :left, :right, :left, :right, "a", "b")
    4.times { find(".site-footer span").click }
    sleep 0.5

    assert_no_selector "#solitaire-window[open]"
  end

  test "typing the code into a field doesn't count" do
    visit new_session_path

    find_field("password").send_keys(*KONAMI)
    sleep 0.5

    assert_no_selector "#solitaire-window[open]"
  end

  private ######################################################################

  def press(*keys)
    page.driver.browser.action.send_keys(*keys).perform
  end
end
