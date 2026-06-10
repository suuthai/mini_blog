class PostsController < ApplicationController
  def index
    @posts = posts
  end

  def create
    Post.create(params.require(:post).permit(:content))
    @new_posts = posts.where("created_at > ?", params[:last_post_created_at])
  end

  private

  def posts
    Post.select(:content, :created_at).order(created_at: :asc)
  end
end
