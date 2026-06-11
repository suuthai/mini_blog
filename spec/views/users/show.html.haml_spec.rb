require 'rails_helper'

RSpec.describe "users/show.html.haml", type: :view do
  it "show user" do
    user = create(:user, email: "do-not-show@this.email.address")
    assign(:user, user)
    render

    expect(rendered).to include(user.name, user.profile_text, user.blog_url)
    expect(rendered).not_to include(user.email)
  end
  
  it "follow button" do
    current_user = create(:user)
    sign_in current_user
    user = create(:user)
    assign(:user, user)
    render

    expect(rendered).to include follow_user_path(user)
    expect(rendered).not_to include unfollow_user_path(user)
  end

  it "unfollow button" do
    current_user = create(:user)
    sign_in current_user
    user = create(:user)
    user.followers << current_user
    assign(:user, user)
    render

    expect(rendered).to include unfollow_user_path(user)
    expect(rendered).not_to include follow_user_path(user)
  end

  it "can't follow myself" do
    current_user = create(:user)
    sign_in current_user
    assign(:user, current_user)
    render

    expect(rendered).not_to include unfollow_user_path(current_user)
    expect(rendered).not_to include follow_user_path(current_user)
  end
end
