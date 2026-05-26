class Page < ApplicationRecord
  validates :slug, presence: true, uniqueness: true
  validates :title, :content, presence: true
end
