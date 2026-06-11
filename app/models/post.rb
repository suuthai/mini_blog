class Post < ApplicationRecord
  belongs_to :user
  
  validates :content, length: { maximum: 140 }  

  scope :of_users_followed_by, ->(user) {
    where(user_id: user.followees.select(:id)) 
  }  
end
