# frozen_string_literal: true

class MigrateTalksToPosts < ActiveRecord::Migration[8.0]
  def up
    Talk.all.each do |talk|
      Post.create!(
        kind: "talk",
        title: talk.title,
        summary: "From #{talk.event_name} (Originally Presented on #{talk.presented_on.strftime("%B %e, %Y")})",
        content: "<div class=\"text-center\">\n<div class=\"video\">#{talk.description}</div>\n<br /><br /><a href=\"#{talk.url}\" target=\"_blank\">Direct Link</a>\n</div>",
        published_at: talk.created_at,
        created_at: talk.created_at,
        updated_at: talk.updated_at
      )
    end
  end

  def down
    Post.where(kind: "talk").destroy_all
  end
end
