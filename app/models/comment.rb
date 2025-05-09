class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy
  include Mentionable

  validates :content, presence: true
  validates :parent_id, presence: true, if: :reply?

  def reply?
    parent_id.present?
  end
end
