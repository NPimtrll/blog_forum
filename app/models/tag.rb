class Tag < ApplicationRecord
  has_many :post_tags
  has_many :posts, through: :post_tags

  validates :name, presence: true

  def self.trending(limit = 5)
    joins(:posts)
      .group("tags.id")
      .order(Arel.sql("COUNT(posts.id) DESC"))
      .limit(limit)
      .select("tags.*, COUNT(posts.id) as post_count")
  end

  def post_count
    self[:post_count] || posts.count
  end
end
