# frozen_string_literal: true

require "application_system_test_case"

class TalksTest < ApplicationSystemTestCase
  test "should get index" do
    visit talks_url

    assert_text "All Talks"

    Talk.find_each do |talk|
      assert_text talk.title
    end
  end
end
