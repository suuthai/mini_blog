require 'rails_helper'

RSpec.describe Post, type: :model do
  it "content length equal or less than 140" do
    expect(build(:post, content: "a" * 141).save).to be false
  end
end
