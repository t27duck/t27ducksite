class ProjectsController < ApplicationController
  def show
    @project          = Project.with_rich_text_content_and_embeds.find(params.expect(:id))
    @page_title       = @project.title
    @page_description = helpers.strip_tags(@project.description).squish
  end
end
