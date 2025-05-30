class User < ApplicationRecord
  has_many :likes, dependent: :destroy
  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :active_follows, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_follows, source: :following

  has_many :passive_follows, class_name: "Follow", foreign_key: "following_id", dependent: :destroy
  has_many :followers, through: :passive_follows, source: :follower
  has_one_attached :avatar

  has_many :bookmarks
  has_many :bookmarked_posts, through: :bookmarks, source: :post

  has_many :notifications, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 20 }
  validates :username, format: { with: /\A[a-zA-Z0-9_]+\z/, message: "ใช้ได้แค่ตัวอักษร ตัวเลข และ _" }

  validates :full_name, presence: true, length: { maximum: 100 }, allow_blank: true

  validates :twitter_url, :linkedin_url, :github_url, format: URI.regexp(%w[http https]), allow_blank: true
  validates :about_me, length: { maximum: 500 }

  validates :email_notifications, :profile_privacy, inclusion: { in: [ true, false ] }

  before_create :set_default_values

  validate :correct_avatar_mime_type
  validate :avatar_size

  private

  def set_default_values
    self.email_notifications ||= true
    self.profile_privacy ||= true
  end

  def correct_avatar_mime_type
    if avatar.attached? && !avatar.content_type.in?(%w[image/png image/jpg image/jpeg])
      errors.add(:avatar, "ต้องเป็นไฟล์ PNG หรือ JPG เท่านั้น")
    end
  end

  def avatar_size
    if avatar.attached? && avatar.blob.byte_size > 5.megabytes
      errors.add(:avatar, "ขนาดไฟล์ต้องไม่เกิน 5MB")
    end
  end
end
