FactoryBot.define do
  factory :notification do
    user
    association :notifiable, factory: :post
    message { "Test notification message" }
    read { false }
  end
end
