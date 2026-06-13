require 'rails_helper'

RSpec.describe "Comments", type: :request do
  describe "GET /index" do
    it "login needed" do
      post = create(:post)
      get "/posts/#{post.id}/comments"
      expect(response).to redirect_to(new_user_session_path) 
    end

    it "no comments" do
      post = create(:post)
      sign_in create(:user)
      get "/posts/#{post.id}/comments"
      expect(response).to have_http_status(:success)
    end

    it "some comments" do
      post = create(:post, comments: [
        create(:comment, content: "Comment 1"),
        create(:comment, content: "Comment 2"),
        create(:comment, content: "Comment 3")
      ])

      sign_in create(:user)
      get "/posts/#{post.id}/comments"
      expect(response.body).to include("Comment 1", "Comment 2", "Comment 3")
    end
  end

  describe "POST /create" do
    it "create" do
      commentee_user = create(:user, email: "commentee-user@example.com")
      post = create(:post, user: commentee_user)
      commenter_user = create(:user, email: "commenter-user@example.com")
      sign_in commenter_user
      ActionMailer::Base.deliveries.clear

      perform_enqueued_jobs do
        post "/posts/#{post.id}/comments", as: :turbo_stream, params: {
          last_comment_created_at: Time.current,
          comment: {
            content: "New Comment"
          }
        }
      end

      expect(response.body).to include("New Comment")
      expect(ActionMailer::Base.deliveries.size).to eq 1
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to include "commentee-user@example.com"
      expect(mail.to).not_to include "commenter-user@example.com"
    end

    it "doesn't send e-mail if the post is mine" do
      commentee_user = create(:user, email: "commentee-user@example.com")
      post = create(:post, user: commentee_user)
      sign_in commentee_user
      ActionMailer::Base.deliveries.clear

      perform_enqueued_jobs do
        post "/posts/#{post.id}/comments", as: :turbo_stream, params: {
          last_comment_created_at: Time.current,
          comment: {
            content: "comment to my post"
          }
        }
      end

      expect(response).to have_http_status(:success)
      expect(ActionMailer::Base.deliveries.size).to eq 0
    end
  end

end
