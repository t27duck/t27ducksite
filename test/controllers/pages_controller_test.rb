require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @page = pages(:about)
  end

  test 'should show post' do
    get page_url(@page)
    assert_response :success
  end
end
