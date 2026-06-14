class Post < ApplicationRecord
  belongs_to :user
  has_many :likes
  has_many :likers, through: :likes, source: :user
  has_many :comments
  has_one_attached :image

  validates :content, length: { maximum: 140 }
  validates :image, content_type: /\Aimage\/.*\z/

  scope :of_users_followed_by, ->(user) {
    where(user_id: user.followees.select(:id)) 
  }

  scope :on_the_timeline, -> {
    joins(:user)
      .select(
        "posts.id" \
        ", posts.content" \
        ", posts.created_at" \
        ", posts.user_id" \
        ", posts.likes_count" \
        ", users.name AS user_name")
      .order(created_at: :asc)
  }
end
