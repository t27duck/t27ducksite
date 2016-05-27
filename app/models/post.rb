class Post < ApplicationRecord
  validates :title, :content, presence: true

  def publish
    published_at.present?
  end

  def publish=(value)
    if ActiveRecord::Type::Boolean.new.cast(value)
      self.published_at ||= Time.now
    else
      self.published_at = nil
    end
  end
end
