require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    it "login needed" do
      get "/posts"
      expect(response).to redirect_to(new_user_session_path) 
    end

    it "returns http success" do
      sign_in create(:user)
      get "/posts"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /posts/followed_only" do
    it "login needed" do
      get "/posts/followed_only"
      expect(response).to redirect_to(new_user_session_path) 
    end

    it "returns http success" do
      current_user = create(:user)
      followed_user = create(:user)
      not_followed_user = create(:user)
      current_user.followees << followed_user
      followed_user_post = create(:post, user: followed_user)
      not_followed_user_post = create(:post, user: not_followed_user)
      sign_in current_user
      get "/posts/followed_only"

      expect(response.body).to include(followed_user_post.content)
      expect(response.body).not_to include(not_followed_user_post.content)
    end
  end

  describe "POST /posts" do
    it "login needed" do
      get "/posts"
      expect(response).to redirect_to(new_user_session_path) 
    end

    it "returns http success and responses valid data" do
      sign_in create(:user)

      post "/posts", as: :turbo_stream, params: {
        last_post_created_at: Time.new(2026, 6, 10, 1, 2, 3),
        post: {
          content: "New Post"
        }
      }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("New Post")
    end

    it "posts from multiple sessions" do
      session_a = open_session
      session_a_start_time = Time.current - 2000
      session_a.sign_in create(:user)

      session_a.post "/posts", as: :turbo_stream, params: {
        last_post_created_at: session_a_start_time,
        post: {
          content: "Post from A"
        }
      }

      session_b = open_session
      session_b_start_time = session_a_start_time - 2000
      session_b.sign_in create(:user)

      session_b.post "/posts", as: :turbo_stream, params: {
        last_post_created_at: session_b_start_time,
        post: {
          content: "Post from B"
        }
      }

      expect(session_a.response.body).to include("Post from A")
      expect(session_b.response.body).to include("Post from A", "Post from B")
    end    
  end

end
