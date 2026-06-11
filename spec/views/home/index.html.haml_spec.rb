require 'rails_helper'

RSpec.describe "home/index.html.haml", type: :view do
  it "loading posts at first" do
    user = create(:user, name: "thisIsTestUser")
    sign_in user
    render

    expect(rendered).to include(user.name)
    assert_select ".loading-posts"
  end
end
