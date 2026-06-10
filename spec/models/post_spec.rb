require 'rails_helper'

RSpec.describe Post, type: :model do
  it "content length equal or less than 140" do
    expect(Post.new(content: "A" * 141)).to be_invalid
  end
end
