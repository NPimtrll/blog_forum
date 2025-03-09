class User < ApplicationRecord
  has_many :likes, dependent: :destroy
  has_many :posts
  has_many :comments, dependent: :destroy
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
