class Project < ApplicationRecord
  KINDS = ["rubygem", "website", "web app"].freeze
  WEB_URL = %r{\Ahttps?://\S+\z}

  has_rich_text :content

  validates :title, :description, presence: true
  validates :repo_url, format: { with: WEB_URL }, allow_blank: true
  validates :kind, presence: true, inclusion: { in: KINDS }

  def to_param
    "#{id}-#{title}".parameterize
  end
end
