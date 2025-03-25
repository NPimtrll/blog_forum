require 'rails_helper'

RSpec.describe Follow, type: :model do
  let(:follow) { build(:follow) }

  describe "Associations" do
    it "belongs to a follower" do
      expect(Follow.reflect_on_association(:follower).macro).to eq :belongs_to
      expect(Follow.reflect_on_association(:follower).class_name).to eq "User"
    end

    it "belongs to a following" do
      expect(Follow.reflect_on_association(:following).macro).to eq :belongs_to
      expect(Follow.reflect_on_association(:following).class_name).to eq "User"
    end
  end

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(follow).to be_valid
    end

    it "is invalid without a follower" do
      follow.follower = nil
      expect(follow).to_not be_valid
      expect(follow.errors[:follower]).to include("must exist")
    end

    it "is invalid without a following" do
      follow.following = nil
      expect(follow).to_not be_valid
      expect(follow.errors[:following]).to include("must exist")
    end

  end
end 