class PostsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @posts = posts
    @followed_only = false
  end

  def followed_only
    @posts = posts.of_users_followed_by(current_user)
    @followed_only = true
    render :index
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
