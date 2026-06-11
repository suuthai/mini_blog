require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /show" do
    it "login needed" do
      user = create(:user)
      get "/users/#{user.id}"
      expect(response).to redirect_to(new_user_session_path) 
    end

    it "returns http success" do
      user = create(:user)
      sign_in user
      get "/users/#{user.id}"
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /follow" do
    it "follow" do
      current_user = create(:user)
      user = create(:user)
      sign_in current_user
      expect(user.followers.include?(current_user)).to be false
      patch "/users/#{user.id}/follow", as: :turbo_stream
      expect(user.followers.include?(current_user)).to be true
    end
    
    it "can't follow myself" do
      current_user = create(:user)
      sign_in current_user
      expect(current_user.followers.include?(current_user)).to be false
      patch "/users/#{current_user.id}/follow", as: :turbo_stream
      expect(current_user.followers.include?(current_user)).to be false
    end
  end

  describe "PATCH /unfollow" do
    it "unfollow" do
      current_user = create(:user)
      user = create(:user)
      user.followers << current_user
      sign_in current_user
      expect(user.followers.include?(current_user)).to be true
      patch "/users/#{user.id}/unfollow", as: :turbo_stream
      expect(user.followers.include?(current_user)).to be false
    end
  end

end
