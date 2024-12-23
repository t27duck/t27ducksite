# frozen_string_literal: true

class Post < ApplicationRecord
  KINDS = ["post", "talk"].freeze

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, :content, presence: true
  validates :kind, presence: true, inclusion: { in: KINDS }

  scope :published, -> { where.not(published_at: nil) }
  scope :unpublished, -> { where(published_at: nil) }

  def publish
    published_at.present?
  end

  def publish=(value)
    if ActiveRecord::Type::Boolean.new.cast(value)
      self.published_at ||= Time.now.utc
    else
      self.published_at = nil
    end
  end

  def tags_input=(tag_names)
    self.tags = tag_names.split(",").filter_map do |name|
      Tag.where(name: name.parameterize).first_or_create! if name.present?
    end
  end

  def tags_input
    tags.map(&:name).join(",")
  end

  def to_param
    "#{id}-#{title}".parameterize
  end
end
