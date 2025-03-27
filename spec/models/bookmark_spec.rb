require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end

  describe "validations" do
    subject { create(:bookmark) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:post_id) }
  end

  describe "factory" do
    it "has a valid factory" do
      bookmark = build(:bookmark)
      expect(bookmark).to be_valid
    end
  end

  describe "uniqueness validation" do
    let(:user) { create(:user) }
    let(:post) { create(:post) }
    
    it "should not allow duplicate bookmarks" do
      create(:bookmark, user: user, post: post)
      duplicate_bookmark = build(:bookmark, user: user, post: post)
      
      expect(duplicate_bookmark).not_to be_valid
      expect(duplicate_bookmark.errors[:user_id]).to include("has already been taken")
    end
  end
end
