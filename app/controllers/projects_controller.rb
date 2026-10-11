class ProjectsController < ApplicationController
  allow_unauthenticated_access

  def index
    @page_title = "Projects"
    @projects = Project.order(:created_at)
  end

  def show
    @project          = Project.with_rich_text_content_and_embeds.find(params.expect(:id))
    @page_title       = @project.title
    @page_description = helpers.strip_tags(@project.description).squish
  end
end
