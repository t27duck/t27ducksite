# frozen_string_literal: true

module ApplicationHelper
  def tag_links(tags)
    tags.map do |tag|
      link_to tag.name, tag_posts_path(tag.name)
    end.join(", ").html_safe # rubocop:disable Rails/OutputSafety
  end
end
