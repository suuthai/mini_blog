class CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @post = Post.select(:id).find(params[:post_id])
    @comments = Comment.on_the_timeline_of(@post)
  end

  def create
    content = params.require(:comment).permit(:content)[:content]
    @post = Post.select(:id, :user_id, :content).find(params[:post_id])
    new_comment = @post.comments.create(content: content, user_id: current_user.id)

    if !new_comment.persisted?
      render :unprocessable_entity and return
    end

    if @post.user_id != new_comment.user_id
      UserMailer.with(post: @post, comment: new_comment).comment.deliver_later
    end

    @new_comments = Comment.on_the_timeline_of(@post)
      .where("comments.created_at > ?", params[:last_comment_created_at])
  end
end
