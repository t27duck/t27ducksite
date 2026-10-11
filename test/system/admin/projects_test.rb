require "application_system_test_case"

class Admin::ProjectsTest < ApplicationSystemTestCase
  setup do
    visit new_session_path
    fill_in "password", with: TEST_ENV_PASSWORD
    click_button "Sign in"

    # Wait for the login to land before navigating, otherwise the next visit can
    # race the redirect and get bounced by authenticate_user!.
    assert_text "Sign out"
  end

  test "editing details through the editor saves them" do
    visit edit_admin_project_path(projects(:one))

    find("lexxy-editor [contenteditable=true]").click
    send_keys [:control, "a"]
    send_keys "Rewritten in the editor"
    click_on "Update Project"

    assert_current_path admin_projects_path
    assert_equal "Rewritten in the editor", projects(:one).reload.content.to_plain_text
  end
end
