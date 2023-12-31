# frozen_string_literal: true

class Talk < ApplicationRecord
  validates :title, :url, :event_name, :presented_on, presence: true
end
