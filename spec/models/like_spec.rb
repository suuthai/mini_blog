require 'rails_helper'

RSpec.describe Like, type: :model do
  it "unique" do
    user = create(:user)
    post = create(:post)
    create(:like, user: user, post: post)
    expect { create(:like, user: user, post: post) }.to raise_error ActiveRecord::RecordNotUnique
  end
end
