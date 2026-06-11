require 'rails_helper'

RSpec.describe Follow, type: :model do
  it "unique" do
    follower = create(:user)
    followee = create(:user)
    create(:follow, follower: follower, followee: followee)
    expect { create(:follow, follower: follower, followee: followee) }.to raise_error ActiveRecord::RecordNotUnique
  end
end
