class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts
  has_many :follower_follows, class_name: "Follow", foreign_key: :followee_id
  has_many :followers, through: :follower_follows
  has_many :followee_follows, class_name: "Follow", foreign_key: :follower_id
  has_many :followees, through: :followee_follows

  validates :name, length: { maximum: 20 }, format: { with: /\A[a-zA-Z]+\z/ }
  validates :profile_text, length: { maximum: 200 }
end
