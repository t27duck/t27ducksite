module ApplicationHelper
  def tag_links(tags)
    safe_join(tags.map { |tag| link_to tag.name, tag }, ", ")
  end

  # A project's description is admin-entered HTML; only inline formatting and links survive.
  def project_description(project)
    sanitize project.description, tags: ["a", "br", "code", "em", "p", "strong"], attributes: ["href", "rel", "target", "title"]
  end

  def current_section
    case controller_path
    when "posts", "tags" then @post&.talk? ? :talks : :posts
    when "talks" then :talks
    when "projects" then :projects
    end
  end
end
