require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get projects_url

    assert_response :success
    assert_select "h1", "All projects"
    assert_select ".site-nav a[aria-current]", count: 1, text: "Projects"
  end

  test "index lists projects oldest first" do
    get projects_url

    assert_equal projects(:oldest).title, css_select("h2.entry-title").first.text
  end

  test "index lists projects with their descriptions" do
    get projects_url

    assert_select ".entry-title a[href=?]", project_path(projects(:one)), text: "Proejct 1"
    assert_select ".entry-title a[href=?]", project_path(projects(:two)), text: "Project 2"
    assert_select ".entry-summary a[href=?]", "https://example.com/docs", text: "Docs"
  end

  test "index without projects" do
    Project.destroy_all
    get projects_url

    assert_response :success
    assert_select "p", "No projects yet."
  end

  test "should show project with details" do
    project = projects(:one)
    get project_url(project)

    assert_response :success
    assert_select ".prose", text: "Project details"
  end

  test "show is in the projects section and closes back to the list" do
    get project_url(projects(:one))

    assert_select ".site-nav a[aria-current]", count: 1, text: "Projects"
    assert_select ".titlebar a.close[href=?]", projects_path
  end

  test "should show project without details" do
    get project_url(projects(:two))

    assert_response :success
    assert_select ".prose", count: 0
  end
end
