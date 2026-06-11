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

end
