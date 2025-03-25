require 'rails_helper'

RSpec.describe TagsController, type: :controller do
  describe 'GET #find_or_create' do
    it 'returns existing tag' do
      tag = create(:tag, name: "test_tag")
      get :find_or_create, params: { name: "test_tag" }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to include(
        "id" => tag.id,
        "name" => tag.name
      )
    end

    it 'creates new tag' do
      expect {
        get :find_or_create, params: { name: "new_tag" }
      }.to change(Tag, :count).by(1)
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to include(
        "name" => "new_tag"
      )
    end
  end

  describe 'GET #trending' do
    it 'returns trending tags' do
      tag1 = create(:tag, name: "tag1")
      tag2 = create(:tag, name: "tag2")
      create(:post, tags: [tag1])
      create(:post, tags: [tag1])
      create(:post, tags: [tag2])

      get :trending
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).length).to eq(2)
      expect(JSON.parse(response.body).first["name"]).to eq("tag1")
    end
  end
end 