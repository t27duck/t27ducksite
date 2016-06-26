class Page < ApplicationRecord
  validates :slug, presence: true, uniqueness: true
  validates :content, presence: true
end
