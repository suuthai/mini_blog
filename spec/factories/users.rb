FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user" + ('A'..'Z').to_a[n - 1] }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "aaaaaa" }
    password_confirmation { "aaaaaa" }
    profile_text { "Profile Text" }
    blog_url { "https://blog.com/foo-bar" }
  end
end
