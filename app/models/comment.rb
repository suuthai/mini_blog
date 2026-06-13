class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :content, length: { maximum: 140 }

  scope :on_the_timeline_of, ->(post) {
    joins(:user)
      .select(
        "comments.id" \
        ", comments.post_id" \
        ", comments.user_id" \
        ", comments.content" \
        ", comments.created_at" \
        ", users.name AS user_name")
      .where(post_id: post.id)
      .order(created_at: :asc)
  }
end
