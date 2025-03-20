class Post < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one :post_category, dependent: :destroy
  has_one :category, through: :post_category
  has_many :post_tags
  has_many :tags, through: :post_tags
  belongs_to :user
  has_one_attached :cover_image

  validates :title, presence: true
  validates :content, presence: true
  validates :excerpt, length: { maximum: 200 }, allow_blank: true
  validates :category_id, presence: true

  attr_accessor :category_id

  after_save :update_category

  private

  def update_category
    if category_id.present?
      post_category&.destroy
      PostCategory.create(post: self, category_id: category_id)
    end
  end
end
