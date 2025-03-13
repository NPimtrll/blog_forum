class User < ApplicationRecord
  has_many :likes, dependent: :destroy
  has_many :posts
  has_many :comments, dependent: :destroy
  has_one_attached :avatar
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validate :correct_avatar_mime_type
  validate :avatar_size

  private

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
