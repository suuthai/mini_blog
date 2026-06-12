require 'rails_helper'

RSpec.describe "posts/index.html.haml", type: :view do
  include PostsHelper

  it "no posts" do
    assign(:posts, [])
    render

    assert_select "#no-posts"
  end

  it "some posts" do
    post1 = create(:post, created_at: Time.new(2026, 6, 10, 1, 2, 3), likers: create_list(:user, 3))
    post2 = create(:post, created_at: Time.new(2026, 6, 10, 4, 5, 6), likers: create_list(:user, 8))
    sign_in post1.user
    assign(:posts, Post.on_the_timeline)
    render

    expect(rendered).to include(
      post1.user.name, post1.content, "2026/06/10 01:02",
      post2.user.name, post2.content, "2026/06/10 04:05"
    )
    
    assert_select "\##{post_element_id(post1)} .likes-count", "3"
    assert_select "\##{post_element_id(post2)} .likes-count", "8"
  end
  
  it "can't post when only posts of followed users are displayed" do
    assign(:posts, [])
    assign(:followed_only, true)
    render

    assert_select "#post-form", false
  end

end
