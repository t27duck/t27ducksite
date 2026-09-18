class Post < ApplicationRecord
  KINDS = ["post", "talk"].freeze
  # Anchored at both ends, and pinned to https, so a video_url can never carry a
  # javascript: scheme into the "Direct Link" href in posts/_video.
  YOUTUBE_URL = %r{\Ahttps://(?:www\.)?youtube\.com/(?:watch\?v=|embed/)([A-Za-z0-9_-]{11})(?:[&?#]\S*)?\z}

  has_rich_text :content

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, presence: true
  validates :kind, presence: true, inclusion: { in: KINDS }
  validates :content, presence: true, unless: :talk?
  validates :video_url, presence: true, if: :talk?
  validates :video_url, format: { with: YOUTUBE_URL }, allow_blank: true

  scope :published, -> { where.not(published_at: nil) }
  scope :unpublished, -> { where(published_at: nil) }

  def talk?
    kind == "talk"
  end

  def youtube_id
    video_url.to_s[YOUTUBE_URL, 1]
  end

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
