class Post < ApplicationRecord
  validates :title, :content, presence: true

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

  def to_param
    "#{id}-#{title}".parameterize
  end
end
