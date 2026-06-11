FactoryBot.define do
  factory :post do
    sequence(:content) { |n| "Post #{n}" }
    user
  end
end
