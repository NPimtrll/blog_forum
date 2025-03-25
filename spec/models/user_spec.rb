require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe "Validations" do
    it "is invalid without a username" do
      user.username = nil
      expect(user).to_not be_valid
    end

    it "is invalid with a duplicate username" do
      create(:user, username: "testuser")
      duplicate_user = build(:user, username: "testuser")
      expect(duplicate_user).to_not be_valid
    end

    it "is invalid if username is too short" do
      user.username = "a"
      expect(user).to_not be_valid
    end

    it "is invalid if username is too long" do
      user.username = "a" * 21
      expect(user).to_not be_valid
    end

    it "is invalid with an incorrect username format" do
      user.username = "invalid username!"
      expect(user).to_not be_valid
    end

    it "is invalid without an email" do
      user.email = nil
      expect(user).to_not be_valid
    end

    it "is invalid with an incorrect email format" do
      user.email = "invalid-email"
      expect(user).to_not be_valid
    end

    it "is invalid if full_name exceeds 100 characters" do
      user.full_name = "a" * 101
      expect(user).to_not be_valid
    end

    it "is invalid if about_me exceeds 500 characters" do
      user.about_me = "a" * 501
      expect(user).to_not be_valid
    end
  end

  describe "Avatar Validations" do
    it "rejects invalid image types" do
      invalid_image = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'invalid_image.txt'), 'text/plain')
      user.avatar.attach(invalid_image)
      expect(user).to_not be_valid
      expect(user.errors[:avatar]).to include("ต้องเป็นไฟล์ PNG หรือ JPG เท่านั้น")
    end
  end
end
