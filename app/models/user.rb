class User < ApplicationRecord
  has_many :likes, dependent: :destroy
  has_many :posts
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
