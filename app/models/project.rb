class Project < ApplicationRecord
  KINDS = ["rubygem", "website", "web app"].freeze
  # Pinned to http(s) so a url can never carry a javascript: scheme into the
  # project links on the home page and the project's own page.
  WEB_URL = %r{\Ahttps?://\S+\z}

  # Optional long-form write-up (text, screenshots) shown on the project's own
  # page. The description column stays as the short summary on the home page.
  has_rich_text :content

  validates :title, :description, :url, presence: true
  validates :url, format: { with: WEB_URL }, allow_blank: true
  validates :kind, presence: true, inclusion: { in: KINDS }

  def to_param
    "#{id}-#{title}".parameterize
  end
end
