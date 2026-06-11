FactoryBot.define do
  factory :user do
    sequence(:name) do |n|
      a_to_z = ('A'..'Z').to_a
      "user" +
        ([ "" ] + a_to_z)[(n / (a_to_z. length + 1)).floor] +
        a_to_z[(n - 1) % a_to_z.length]
    end

    sequence(:email) { |n| "test#{n}@example.com" }
    password { "aaaaaa" }
    password_confirmation { "aaaaaa" }
    profile_text { "Profile Text" }
    blog_url { "https://blog.com/foo-bar" }
  end
end
