module ApplicationHelper
  def tag_links(tags)
    tags.map do |tag|
      link_to tag.name, tag_posts_path(tag.name)
    end.join(", ").html_safe # rubocop:disable Rails/OutputSafety
  end

  # Which header nav item is current. A talk's own page is served by
  # PostsController, so it counts as Talks.
  def current_section
    return :talks if controller_path == "talks" || (controller_path == "posts" && @post&.talk?)

    :posts if controller_path == "posts"
  end
end
