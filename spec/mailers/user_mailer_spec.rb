require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  it "comment" do
    user = create(:user,
      name: "commenteeUser",
      email: "commentee-user@example.com",
      posts: [
        create(:post,
          content: "Post",
          comments: [
            create(:comment,
              content: "Comment",
              user: create(:user,
                name: "commenterUser",
                email: "commenter-user@example.com"
              )
            )
          ]
        )
      ]
    )

    post = user.posts.first
    comment = post.comments.first
    mail = UserMailer.with(post: post, comment: comment).comment

    expect(mail.to).to eq [ "commentee-user@example.com" ]
    expect(mail.body).to include "commenteeUser", "commenterUser", "Post", "Comment"
    expect(mail.body).not_to include "commenter-user@example.com"
  end
end
