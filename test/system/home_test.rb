# frozen_string_literal: true

require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase
  test "User can visit root page" do
    visit root_path

    assert_text "Hello!"
    assert_text "Recent Stuff"
  end
end
