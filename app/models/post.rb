class Post < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  belongs_to :category
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  belongs_to :user
  has_one_attached :cover_image

  validates :title, presence: true
  validates :content, presence: true
  validates :excerpt, length: { maximum: 200 }, allow_blank: true
  validates :category, presence: true

  scope :published, -> { where.not(published_at: nil) }
  scope :draft, -> { where(published_at: nil) }

  validate :acceptable_cover_image

  private

  def acceptable_cover_image
    return unless cover_image.attached?

    unless cover_image.blob.content_type.in?(%w[image/jpeg image/png])
      errors.add(:cover_image, "ต้องเป็นไฟล์ PNG หรือ JPG เท่านั้น")
    end
  end
end
