class Page < ApplicationRecord
  validates :slug, presence: true, uniqueness: true
  validates :content, presence: true

  def to_param
    slug
  end
end
