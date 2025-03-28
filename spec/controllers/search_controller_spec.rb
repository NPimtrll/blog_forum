require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe "GET #index" do
    context "when no query parameter is provided" do
      it "returns success" do
        get :index
        expect(response).to be_successful
      end

      it "assigns empty results" do
        get :index
        expect(assigns(:posts)).to be_nil
        expect(assigns(:users)).to be_nil
        expect(assigns(:categories)).to be_nil
      end
    end

    context "when query parameter is provided" do
      let!(:post) { create(:post, :with_tags, title: "Test Post", content: "Test Content") }
      let!(:user) { create(:user, username: "testuser", full_name: "Test User") }
      let!(:category) { create(:category, name: "Test Category", description: "Test Description") }

      before do
        # Mock Post query chain
        post_relation = double("Post::ActiveRecord_Relation")
        allow(Post).to receive(:where).with("title ILIKE ? OR content ILIKE ?", "%test%", "%test%").and_return(post_relation)
        allow(post_relation).to receive(:includes).with(:user, :category).and_return(post_relation)
        allow(post_relation).to receive(:order).with(created_at: :desc).and_return(post_relation)
        allow(post_relation).to receive(:page).and_return(post_relation)
        allow(post_relation).to receive(:per).with(10).and_return([ post ])

        # Mock User query chain
        user_relation = double("User::ActiveRecord_Relation")
        allow(User).to receive(:where).with("username ILIKE ? OR full_name ILIKE ?", "%test%", "%test%").and_return(user_relation)
        allow(user_relation).to receive(:order).with(created_at: :desc).and_return(user_relation)
        allow(user_relation).to receive(:page).and_return(user_relation)
        allow(user_relation).to receive(:per).with(10).and_return([ user ])

        # Mock Category query chain
        category_relation = double("Category::ActiveRecord_Relation")
        allow(Category).to receive(:where).with("name ILIKE ? OR description ILIKE ?", "%test%", "%test%").and_return(category_relation)
        allow(category_relation).to receive(:order).with(created_at: :desc).and_return(category_relation)
        allow(category_relation).to receive(:page).and_return(category_relation)
        allow(category_relation).to receive(:per).with(10).and_return([ category ])
      end

      it "returns success" do
        get :index, params: { q: "test" }
        expect(response).to be_successful
      end

      it "assigns matching posts" do
        get :index, params: { q: "test" }
        expect(assigns(:posts)).to eq([ post ])
      end

      it "assigns matching users" do
        get :index, params: { q: "test" }
        expect(assigns(:users)).to eq([ user ])
      end

      it "assigns matching categories" do
        get :index, params: { q: "test" }
        expect(assigns(:categories)).to eq([ category ])
      end
    end

    context "when requesting JSON format" do
      let!(:post) { create(:post, :with_tags, title: "Test Post") }
      let!(:user) { create(:user, username: "testuser") }
      let!(:category) { create(:category, name: "Test Category") }

      before do
        # Mock Post query chain
        post_relation = double("Post::ActiveRecord_Relation")
        allow(Post).to receive(:where).with("title ILIKE ? OR content ILIKE ?", "%test%", "%test%").and_return(post_relation)
        allow(post_relation).to receive(:includes).with(:user, :category).and_return(post_relation)
        allow(post_relation).to receive(:order).with(created_at: :desc).and_return(post_relation)
        allow(post_relation).to receive(:page).and_return(post_relation)
        allow(post_relation).to receive(:per).with(10).and_return([ post ])

        # Mock User query chain
        user_relation = double("User::ActiveRecord_Relation")
        allow(User).to receive(:where).with("username ILIKE ? OR full_name ILIKE ?", "%test%", "%test%").and_return(user_relation)
        allow(user_relation).to receive(:order).with(created_at: :desc).and_return(user_relation)
        allow(user_relation).to receive(:page).and_return(user_relation)
        allow(user_relation).to receive(:per).with(10).and_return([ user ])

        # Mock Category query chain
        category_relation = double("Category::ActiveRecord_Relation")
        allow(Category).to receive(:where).with("name ILIKE ? OR description ILIKE ?", "%test%", "%test%").and_return(category_relation)
        allow(category_relation).to receive(:order).with(created_at: :desc).and_return(category_relation)
        allow(category_relation).to receive(:page).and_return(category_relation)
        allow(category_relation).to receive(:per).with(10).and_return([ category ])
      end

      it "returns JSON with correct structure" do
        get :index, params: { q: "test", format: :json }

        json_response = JSON.parse(response.body)

        expect(json_response).to include(
          "posts",
          "users",
          "categories"
        )
      end

      it "includes correct post data" do
        get :index, params: { q: "test", format: :json }

        json_response = JSON.parse(response.body)
        post_data = json_response["posts"].first

        expect(post_data).to include(
          "id" => post.id,
          "title" => post.title,
          "user_email" => post.user.email
        )
      end

      it "includes correct user data" do
        get :index, params: { q: "test", format: :json }

        json_response = JSON.parse(response.body)
        user_data = json_response["users"].first

        expect(user_data).to include(
          "id" => user.id,
          "username" => user.username
        )
      end

      it "includes correct category data" do
        get :index, params: { q: "test", format: :json }

        json_response = JSON.parse(response.body)
        category_data = json_response["categories"].first

        expect(category_data).to include(
          "id" => category.id,
          "name" => category.name
        )
      end
    end
  end
end
