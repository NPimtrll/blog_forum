FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    full_name { "Test User" }
    about_me { "This is a test user" }
    email_notifications { true }
    profile_privacy { false }
    password_confirmation { "password123" }
  end
end
