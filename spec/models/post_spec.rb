require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { build(:post) }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(post).to be_valid
    end

    it "is invalid without a title" do
      post.title = nil
      expect(post).to_not be_valid
      expect(post.errors[:title]).to include("can't be blank")
    end

    it "is invalid without content" do
      post.content = nil
      expect(post).to_not be_valid
      expect(post.errors[:content]).to include("can't be blank")
    end

    it "is invalid without a category" do
      post.category = nil
      expect(post).to_not be_valid
      expect(post.errors[:category]).to include("must exist")
    end

    it "is invalid without a user" do
      post.user = nil
      expect(post).to_not be_valid
      expect(post.errors[:user]).to include("must exist")
    end

    it "is invalid with excerpt longer than 200 characters" do
      post.excerpt = "a" * 201
      expect(post).to_not be_valid
      expect(post.errors[:excerpt]).to include("is too long (maximum is 200 characters)")
    end
  end

  describe "Associations" do
    it "belongs to a user" do
      expect(Post.reflect_on_association(:user).macro).to eq :belongs_to
    end

    it "belongs to a category" do
      expect(Post.reflect_on_association(:category).macro).to eq :belongs_to
    end

    it "has many comments" do
      expect(Post.reflect_on_association(:comments).macro).to eq :has_many
    end

    it "has many likes" do
      expect(Post.reflect_on_association(:likes).macro).to eq :has_many
    end

    it "has many tags through post_tags" do
      expect(Post.reflect_on_association(:tags).macro).to eq :has_many
    end
  end

  describe "Cover Image" do
    it "can attach a cover image" do
      post = create(:post, :with_cover_image)
      expect(post.cover_image).to be_attached
    end

    it "rejects invalid image types" do
      invalid_image = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'invalid_image.txt'), 'text/plain')
      post.cover_image.attach(invalid_image)
      expect(post).to_not be_valid
      expect(post.errors[:cover_image]).to include("ต้องเป็นไฟล์ PNG หรือ JPG เท่านั้น")
    end
  end

  describe "Tags" do
    it "can have multiple tags" do
      post = create(:post, :with_tags)
      expect(post.tags.count).to eq(2)
      expect(post.tags.pluck(:name)).to include("technology", "programming")
    end
  end

  describe "Scopes" do
    let!(:published_post) { create(:post) }
    let!(:draft_post) { create(:post, :draft) }

    it "can filter published posts" do
      expect(Post.published).to include(published_post)
      expect(Post.published).not_to include(draft_post)
    end

    it "can filter draft posts" do
      expect(Post.draft).to include(draft_post)
      expect(Post.draft).not_to include(published_post)
    end
  end

  describe "Views" do
    it "increments view count" do
      post = create(:post)
      expect { post.increment!(:views) }.to change { post.views }.by(1)
    end
  end
end 