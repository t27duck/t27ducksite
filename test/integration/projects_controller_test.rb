require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  test "should show project with details" do
    project = projects(:one)
    get project_url(project)

    assert_response :success
    assert_select ".prose", text: "Project details"
  end

  test "should show project without details" do
    get project_url(projects(:two))

    assert_response :success
    assert_select ".prose", count: 0
  end
end
