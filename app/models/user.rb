class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts

  validates :name, length: { maximum: 20 }, format: { with: /\A[a-zA-Z]+\z/ }
  validates :profile_text, length: { maximum: 200 }
end
