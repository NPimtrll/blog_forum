require 'rails_helper'

RSpec.describe Tag, type: :model do
  let(:tag) { build(:tag) }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(tag).to be_valid
    end

    it "is invalid without a name" do
      tag.name = nil
      expect(tag).to_not be_valid
      expect(tag.errors[:name]).to include("can't be blank")
    end
  end

  describe "Associations" do
    it "has many post_tags" do
      expect(Tag.reflect_on_association(:post_tags).macro).to eq :has_many
    end

    it "has many posts through post_tags" do
      expect(Tag.reflect_on_association(:posts).macro).to eq :has_many
    end
  end

  describe "Scopes" do
    describe ".trending" do
      let!(:tag1) { create(:tag) }
      let!(:tag2) { create(:tag) }
      let!(:tag3) { create(:tag) }
      let!(:post1) { create(:post, :with_tags) }
      let!(:post2) { create(:post, :with_tags) }
      let!(:post3) { create(:post, :with_tags) }

      it "returns tags ordered by post count" do
        trending_tags = Tag.trending
        expect(trending_tags.first.post_count).to be >= trending_tags.last.post_count
      end

      it "limits the number of results" do
        expect(Tag.trending(2).to_a.size).to eq(2)
      end
    end
  end

  describe "#post_count" do
    let(:tag) { create(:tag) }
    let!(:post1) { create(:post, :with_tags) }
    let!(:post2) { create(:post, :with_tags) }

    it "returns the number of posts associated with the tag" do
      tag.posts << post1
      tag.posts << post2
      expect(tag.post_count).to eq(2)
    end

    it "returns cached post_count when available" do
      trending_tag = Tag.trending.first
      expect(trending_tag.post_count).to eq(trending_tag[:post_count])
    end
  end
end 