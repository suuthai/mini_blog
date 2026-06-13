class UserMailer < ApplicationMailer
  def comment
    @post = params[:post]
    @comment = params[:comment]
    mail(to: @post.user.email, subject: "[Mini-Blog] 投稿にコメントがありました")
  end
end
