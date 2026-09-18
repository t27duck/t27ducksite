require "application_system_test_case"

class Admin::PostsTest < ApplicationSystemTestCase
  setup do
    visit new_session_path
    fill_in "password", with: TEST_ENV_PASSWORD
    click_on "Login"

    # Wait for the login to land before navigating, otherwise the next visit can
    # race the redirect and get bounced by authenticate_user!.
    assert_text "Signout"
  end

  # Lexxy is pre-1.0 and monkey-patches Action Text's form helpers, so a version
  # bump can break the editor without any Ruby-level failure. This asserts the
  # custom element actually upgraded and its JS ran.
  test "the lexxy editor loads the post content" do
    visit edit_admin_post_path(posts(:one))

    assert_selector "lexxy-editor"
    assert_selector "lexxy-editor [contenteditable=true]", text: "Content 1"
  end

  test "editing content through the editor saves it" do
    visit edit_admin_post_path(posts(:one))

    find("lexxy-editor [contenteditable=true]").click
    send_keys [:control, "a"]
    send_keys "Rewritten in the editor"
    click_on "Update Post"

    assert_current_path admin_posts_path
    assert_equal "Rewritten in the editor", posts(:one).reload.content.to_plain_text
  end
end
