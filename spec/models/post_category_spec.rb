require 'rails_helper'

RSpec.describe PostCategory, type: :model do
  let(:post_category) { build(:post_category) }

  describe "Associations" do
    it "belongs to a post" do
      expect(PostCategory.reflect_on_association(:post).macro).to eq :belongs_to
    end

    it "belongs to a category" do
      expect(PostCategory.reflect_on_association(:category).macro).to eq :belongs_to
    end
  end

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(post_category).to be_valid
    end

    it "is invalid without a post" do
      post_category.post = nil
      expect(post_category).to_not be_valid
      expect(post_category.errors[:post]).to include("must exist")
    end

    it "is invalid without a category" do
      post_category.category = nil
      expect(post_category).to_not be_valid
      expect(post_category.errors[:category]).to include("must exist")
    end
  end
end
