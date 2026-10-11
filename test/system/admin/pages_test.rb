require "application_system_test_case"

class Admin::PagesTest < ApplicationSystemTestCase
  setup do
    visit new_session_path
    fill_in "password", with: TEST_ENV_PASSWORD
    click_button "Sign in"

    # Wait for the login to land before navigating, otherwise the next visit can
    # race the redirect and get bounced by authenticate_user!.
    assert_text "Sign out"
  end

  test "editing content through the editor saves it" do
    visit edit_admin_page_path(pages(:about))

    find("lexxy-editor [contenteditable=true]").click
    send_keys [:control, "a"]
    send_keys "Rewritten in the editor"
    click_on "Update Page"

    assert_current_path admin_pages_path
    assert_equal "Rewritten in the editor", pages(:about).reload.content.to_plain_text
  end
end
