require 'rails_helper'

RSpec.describe "posts/index.html.haml", type: :view do
  it "no posts" do
    assign(:posts, [])
    render
    assert_select "#no-posts"
  end

  it "some posts" do
    assign(:posts, [
      Post.new(content: "New Post 1", created_at: Time.new(2026, 6, 10, 1, 2, 3)),
      Post.new(content: "New Post 2", created_at: Time.new(2026, 6, 10, 4, 5, 6))
    ])

    render

    expect(rendered).to include(
      "New Post 1", "2026/06/10 01:02",
      "New Post 2", "2026/06/10 04:05"
    )    
  end
end
