require "application_system_test_case"

class EasterEggTest < ApplicationSystemTestCase
  KONAMI = [:up, :up, :down, :down, :left, :right, :left, :right, "b", "a"].freeze

  test "the Konami code boots the desktop into the post you were reading" do
    visit post_path(posts(:one))

    press(*KONAMI)

    assert_selector "#internet_explorer-window h1", text: "Post 1"
    assert_current_path desktop_path # without ?open, so a reload is a plain desktop
  end

  test "five taps on the copyright boot the desktop into the project you were reading" do
    visit project_path(projects(:one))

    5.times { find(".site-footer span").click }

    assert_selector "#internet_explorer-window h1", text: "Proejct 1"
  end

  test "a talk boots into the Media Player" do
    visit post_path(posts(:three))

    press(*KONAMI)

    assert_selector "#media_player-window .status", text: "Talk 1"
  end

  test "anywhere else boots a plain desktop" do
    visit root_path

    press(*KONAMI)

    assert_selector "footer.taskbar"
    assert_no_selector "dialog[open]"
  end

  test "a wrong key or too few taps stays put" do
    visit post_path(posts(:one))

    assert_stays_on_page do
      press(:up, :up, :down, :down, :left, :right, :left, :right, "a", "b")
      4.times { find(".site-footer span").click }
    end
  end

  test "typing the code into a field doesn't count" do
    visit new_session_path

    assert_stays_on_page { find_field("password").send_keys(*KONAMI) }
  end

  private ######################################################################

  def press(*keys)
    page.driver.browser.action.send_keys(*keys).perform
  end

  # Booting the desktop is a full page load, which would lose the marker.
  def assert_stays_on_page
    execute_script("window.stayed = true")
    yield
    sleep 0.5

    assert evaluate_script("window.stayed === true"), "the easter egg went off"
  end
end
