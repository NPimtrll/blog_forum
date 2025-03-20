class Post < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  belongs_to :category
  has_many :post_tags
  has_many :tags, through: :post_tags
  belongs_to :user
  has_one_attached :cover_image

  validates :title, presence: true
  validates :content, presence: true
  validates :excerpt, length: { maximum: 200 }, allow_blank: true
  validates :category, presence: true

  private

  def update_category
    if category_id.present?
      post_category&.destroy
      PostCategory.create(post: self, category_id: category_id)
    end
  end
end
