class PostsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @posts = Post.on_the_timeline
    @followed_only = false
  end

  def followed_only
    @posts = Post.on_the_timeline.of_users_followed_by(current_user)
    @followed_only = true
    render :index
  end

  def create
    current_user.posts.create!(params.require(:post).permit(:content, :image));
    @new_posts = Post.on_the_timeline.where("posts.created_at > ?", params[:last_post_created_at])
  end

  def like
    @post = Post.select(:id, :user_id, :likes_count).find(params[:id])
    @liked = @post.user_id != current_user.id && (@post.likers << current_user)
    render status: @liked ? :ok : :unprocessable_entity
  end

  def unlike
    @post = Post.select(:id, :user_id, :likes_count).find(params[:id])
    @liked = !(@post.user_id != current_user.id && @post.likers.delete(current_user))
    render :like, status: !@liked ? :ok : :unprocessable_entity
  end

  def likers
    @post = Post.select(:id).find(params[:id])
  end
end
