require 'rails_helper'

RSpec.describe FollowsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe 'POST #create' do
    context 'when user is not logged in' do
      it 'redirects to sign in page' do
        post :create, params: { id: other_user.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is logged in' do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end

      it 'creates a new follow relationship' do
        expect {
          post :create, params: { id: other_user.id }
        }.to change(Follow, :count).by(1)
      end

      it 'does not create duplicate follow relationship' do
        user.following << other_user
        expect {
          post :create, params: { id: other_user.id }
        }.not_to change(Follow, :count)
      end

      it 'redirects back or to root path' do
        post :create, params: { id: other_user.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is not logged in' do
      it 'redirects to sign in page' do
        delete :destroy, params: { id: other_user.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is logged in' do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
        user.following << other_user
      end

      it 'removes the follow relationship' do
        expect {
          delete :destroy, params: { id: other_user.id }
        }.to change(Follow, :count).by(-1)
      end

      it 'redirects back or to root path' do
        delete :destroy, params: { id: other_user.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
