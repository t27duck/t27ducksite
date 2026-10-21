class Desktop::InternetExplorerController < ApplicationController
  allow_unauthenticated_access

  # Browses to a post or project, showing its page as the site does; with
  # neither, a blank page.
  def show
    if params.key?(:post)
      @page = Post.post.published.includes(:tags).with_rich_text_content_and_embeds.find(params.expect(:post))
      @url = post_url(@page)
    elsif params.key?(:project)
      @page = Project.with_rich_text_content_and_embeds.find(params.expect(:project))
      @url = project_url(@page)
    end
  end
end
