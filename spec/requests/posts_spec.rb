require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:image) {
    image_path = Rails.root.join "spec/fixtures/test_image.png"
    image = fixture_file_upload image_path, "image/png"
  }

  describe "GET /posts" do
    it "login needed" do
      get "/posts"
      expect(response).to redirect_to(new_user_session_path) 
    end

    it "some posts" do
      user = create(:user, posts: [
        create(:post, content: "Post 1"),
        create(:post, content: "Post 2"),
        create(:post, content: "Post 3")
      ])

      sign_in user
      get "/posts"
      expect(response).to have_http_status(:success)
      expect(response.body).to include "Post 1", "Post 2", "Post 3"
    end

    it "post with image" do
      user = create(:user, posts: [ create(:post, image: image ) ])
      sign_in user
      get "/posts"
      expect(response).to have_http_status(:success)
      expect(response.body).to include rails_blob_path(user.posts.last.image, disposition: "attachment")
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

    it "attach image file" do
      user = create(:user)
      sign_in user

      post "/posts", as: :turbo_stream, params: {
        last_post_created_at: Time.current,
        post: { content: "Post with Image", image: image }
      }

      expect(response).to have_http_status(:success)
      uploaded_image = user.posts.last.image
      expect(uploaded_image).to be_attached
      expect(uploaded_image.filename.to_s).to eq "test_image.png"
    end
  end

  describe "PATCH /like" do
    it "give other user's post a like but only once" do
      user = create(:user)
      post = create(:post)

      sign_in user
      expect(post.likers.include?(user)).to be false
      first_likes_count = post.likes.count

      patch "/posts/#{post.id}/like", as: :turbo_stream
      expect(post.likers.include?(user)).to be true
      expect(post.likes.count).to be first_likes_count + 1

      expect { patch "/posts/#{post.id}/like", as: :turbo_stream }.to raise_error ActiveRecord::RecordNotUnique
      expect(post.likes.count).to be first_likes_count + 1
    end

    it "can't give my post a like" do
      user = create(:user)
      post = create(:post, user: user)

      sign_in user
      expect(post.likers.include?(user)).to be false
      first_likes_count = post.likes.count

      patch "/posts/#{post.id}/like", as: :turbo_stream
      expect(post.likers.include?(user)).to be false
      expect(post.likes.count).to be first_likes_count
    end
  end

  describe "PATCH /unlike" do
    it "unlike a post but only once" do
      user = create(:user)
      post = create(:post)

      sign_in user
      post.likers << user
      first_likes_count = post.likes.count
      expect(post.likers.include?(user)).to be true

      patch "/posts/#{post.id}/unlike", as: :turbo_stream
      expect(post.likers.include?(user)).to be false
      expect(post.likes.count).to be first_likes_count - 1

      patch "/posts/#{post.id}/unlike", as: :turbo_stream
      expect(post.likes.count).to be first_likes_count - 1
    end
  end

  describe "GET /likers" do
    it "list likers" do
      users = create_list(:user, 3)
      post = create(:post)
      post.likers << users

      sign_in users[0]
      get "/posts/#{post.id}/likers"
      expect(response.body).to include(users[0].name, users[1].name, users[2].name)
    end
  end

end
