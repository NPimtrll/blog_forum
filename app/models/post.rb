class Post < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :post_tags
  has_many :tags, through: :post_tags
  belongs_to :user
  has_one_attached :cover_image

  validates :title, presence: true
  validates :content, presence: true
  validates :excerpt, length: { maximum: 200 }, allow_blank: true
end
