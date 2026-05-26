class Project < ApplicationRecord
  KINDS = ["rubygem", "website", "web app"].freeze

  validates :title, :description, :url, presence: true
  validates :kind, presence: true, inclusion: { in: KINDS }
end
