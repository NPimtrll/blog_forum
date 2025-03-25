FactoryBot.define do
  factory :post do
    title { "Test Post" }
    content { "This is a test post content" }
    excerpt { "This is a test excerpt" }
    views { 0 }
    published_at { Time.current }
    association :user
    association :category

    trait :draft do
      published_at { nil }
    end

    trait :with_tags do
      after(:create) do |post|
        post.tags << create(:tag, name: "technology")
        post.tags << create(:tag, name: "programming")
      end
    end

    trait :with_cover_image do
      after(:build) do |post|
        file_path = Rails.root.join('spec', 'fixtures', 'files', 'valid_image.jpg')
        post.cover_image.attach(io: File.open(file_path), filename: 'valid_image.jpg', content_type: 'image/jpeg')
      end
    end
  end
end 