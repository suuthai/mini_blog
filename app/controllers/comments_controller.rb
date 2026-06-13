class CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @post = Post.select(:id).find(params[:post_id])
    @comments = Comment.on_the_timeline_of(@post)
  end

  def create
    content = params.require(:comment).permit(:content)[:content]
    @post = Post.select(:id).find(params[:post_id])
    ok = @post.comments.create(content: content, user_id: current_user.id)
    @new_comments = Comment.on_the_timeline_of(@post)
      .where("comments.created_at > ?", params[:last_comment_created_at])
    render status: ok ? :ok : :unprocessable_entity
  end
end
