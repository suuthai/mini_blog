FactoryBot.define do
  factory :follow do
    follower { user }
    followee { user }
  end
end
