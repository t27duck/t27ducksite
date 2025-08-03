# frozen_string_literal: true

class Admin::ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:edit, :update, :destroy]

  def index
    @projects = Project.order(:title)
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to admin_projects_path, notice: "Project was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @project.update(project_params)
      redirect_to admin_projects_path, notice: "Project was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @project.destroy
    redirect_to admin_projects_path, notice: "Project was successfully destroyed."
  end

  private ######################################################################

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.expect(project: [:title, :kind, :description, :url])
  end
end
