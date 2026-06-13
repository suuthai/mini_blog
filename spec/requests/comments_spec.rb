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
      post = create(:post)
      sign_in create(:user)

      post "/posts/#{post.id}/comments/create", as: :turbo_stream, params: {
        last_comment_created_at: Time.current,
        comment: {
          content: "New Comment"
        }
      }

      expect(response.body).to include("New Comment")
    end
  end

end
