require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    it "returns http success" do
      get "/posts"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /posts" do
    it "returns http success and responses valid data" do
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
      session_b = open_session

      session_a.post "/posts", as: :turbo_stream, params: {
        last_post_created_at: Time.current,
        post: {
          content: "Post from Session A"
        }
      }

      expect(session_a.response.body).to include("Post from Session A")

      session_b.post "/posts", as: :turbo_stream, params: {
        last_post_created_at: Time.current - 1000,
        post: {
          content: "Post from Session B"
        }
      }

      expect(session_b.response.body).to include(
        "Post from Session A",
        "Post from Session B"
      )
    end    
  end

end
