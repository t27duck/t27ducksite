# frozen_string_literal: true

require "test_helper"

class Admin::ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = projects(:one)
    login_user
  end

  test "should get index" do
    get admin_projects_url

    assert_response :success
  end

  test "should create project" do
    assert_difference("Project.count") do
      post admin_projects_url, params: {
        project: {
          description: @project.description, kind: "rubygem", url: @project.url,
          title: @project.title
        }
      }
    end

    assert_redirected_to admin_projects_path
  end

  test "should not create project if not valid" do
    assert_no_difference("Project.count") do
      post admin_projects_url, params: {
        project: {
          kind: "website", description: @project.description, title: ""
        }
      }
    end
    assert_response :unprocessable_content
  end

  test "should get edit" do
    get edit_admin_project_url(@project)

    assert_response :success
  end

  test "should update project" do
    patch admin_project_url(@project), params: {
      project: { title: @project.title, description: @project.description }
    }

    assert_redirected_to admin_projects_path
  end

  test "should not update project if not valid" do
    patch admin_project_url(@project), params: {
      project: { description: "" }
    }

    assert_response :unprocessable_content
  end

  test "should destroy project" do
    assert_difference("Project.count", -1) do
      delete admin_project_url(@project)
    end

    assert_redirected_to admin_projects_path
  end
end
