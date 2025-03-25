FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:username) { |n| "user_#{n}" }
    full_name { Faker::Name.name }
    about_me { Faker::Lorem.sentence(word_count: 10) }
    email_notifications { true }
    profile_privacy { false }
    password { "password123" }
    password_confirmation { "password123" }
  end
end
