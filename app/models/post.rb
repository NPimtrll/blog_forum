class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_by, through: :bookmarks, source: :user
  has_one_attached :cover_image
  include Mentionable

  validates :title, presence: true
  validates :content, presence: true
  validates :excerpt, length: { maximum: 200 }, allow_blank: true
  validates :category, presence: true

  scope :published, -> { where.not(published_at: nil) }
  scope :draft, -> { where(published_at: nil) }

  validate :acceptable_cover_image

  after_create :notify_followers

  private

  def acceptable_cover_image
    return unless cover_image.attached?

    unless cover_image.blob.content_type.in?(%w[image/jpeg image/png])
      errors.add(:cover_image, "ต้องเป็นไฟล์ PNG หรือ JPG เท่านั้น")
    end
  end

  def notify_followers
    user.followers.each do |follower|
      Notification.create!(
        user: follower,
        notifiable: self,
        message: "#{user.username} posted a new topic: #{title}",
        read: false
      )
    end
  end
end
