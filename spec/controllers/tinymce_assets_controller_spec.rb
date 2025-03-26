require 'rails_helper'

RSpec.describe TinymceAssetsController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_image) { fixture_file_upload('spec/fixtures/files/valid_image.jpg', 'image/jpeg') }
  let(:invalid_file) { fixture_file_upload('spec/fixtures/files/invalid_image.txt', 'text/plain') }

  describe 'POST #create' do
    context 'when user is not logged in' do
      it 'redirects to sign in page' do
        post :create, params: { file: valid_image }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is logged in' do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end

      it 'creates a new image with valid file' do
        expect {
          post :create, params: { file: valid_image }
        }.to change(Image, :count).by(1)
      end

      it 'returns JSON with image location' do
        post :create, params: { file: valid_image }
        expect(response.content_type).to include('application/json')
        expect(JSON.parse(response.body)).to have_key('location')
      end

      it 'handles invalid file type' do
        post :create, params: { file: invalid_file }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('error')
      end

      it 'handles missing file parameter' do
        post :create, params: {}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('error')
      end
    end
  end
end 