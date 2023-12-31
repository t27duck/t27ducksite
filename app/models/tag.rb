# frozen_string_literal: true

class Tag < ApplicationRecord
  has_many :taggings # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :posts, through: :taggings

  validates :name, uniqueness: true, presence: true

  def name=(value)
    value = value.parameterize if value.is_a?(String)
    super(value)
  end
end
