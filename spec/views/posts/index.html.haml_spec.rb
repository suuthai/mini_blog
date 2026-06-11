require 'rails_helper'

RSpec.describe "posts/index.html.haml", type: :view do
  it "no posts" do
    assign(:posts, [])
    render

    assert_select "#no-posts"
  end

  it "some posts" do
    post1 = create(:post, created_at: Time.new(2026, 6, 10, 1, 2, 3))
    post2 = create(:post, created_at: Time.new(2026, 6, 10, 4, 5, 6))
    assign(:posts, Post.joins(:user).select("posts.*, users.name AS user_name"))
    render

    expect(rendered).to include(
      post1.user.name, post1.content, "2026/06/10 01:02",
      post2.user.name, post2.content, "2026/06/10 04:05"
    )    
  end
end
