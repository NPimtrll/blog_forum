FactoryBot.define do
  factory :follow do
    follower { create(:user) }
    following { create(:user) }
  end
end
