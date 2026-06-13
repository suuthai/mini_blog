FactoryBot.define do
  factory :comment do
    sequence(:content) { |n| "Comment #{n}" }
    post
    user
  end
end
