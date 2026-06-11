require 'rails_helper'

RSpec.describe "users/show.html.haml", type: :view do
  it "show user" do
    user = build(:user, email: "do-not-show@this.email.address")
    assign(:user, user)
    render

    expect(rendered).to include(user.name, user.profile_text, user.blog_url)
    expect(rendered).not_to include(user.email)
  end
end
