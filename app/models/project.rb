# frozen_string_literal: true

class Project < ApplicationRecord
  KINDS = ["rubygem", "website"].freeze

  validates :title, :description, :url, presence: true
  validates :kind, presence: true, inclusion: { in: KINDS }
end
