class PostsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @posts = posts
  end

  def create
    current_user.posts.create!(params.require(:post).permit(:content));
    @new_posts = posts.where("posts.created_at > ?", params[:last_post_created_at])
  end

  private

  def posts
    Post.joins(:user)
      .select("posts.content, posts.created_at, posts.user_id, users.name AS user_name")
      .order(created_at: :asc)
  end
end
