require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:user) { create(:user) }
  let(:post_obj) { create(:post, user: user) }

  describe 'POST #create' do
    context 'when user is not logged in' do
      it 'redirects to sign in page' do
        post :create, params: { post_id: post_obj.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is logged in' do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end

      it 'creates a new like' do
        expect {
          post :create, params: { post_id: post_obj.id }
        }.to change(Like, :count).by(1)
      end

      it 'removes the like when already liked' do
        create(:like, user: user, post: post_obj)
        expect {
          post :create, params: { post_id: post_obj.id }
        }.to change(Like, :count).by(-1)
      end

      it 'redirects to post page' do
        post :create, params: { post_id: post_obj.id }
        expect(response).to redirect_to(post_obj)
      end

      it 'sets success message when liking' do
        post :create, params: { post_id: post_obj.id }
        expect(flash[:notice]).to eq("You liked this post.")
      end

      it 'sets success message when unliking' do
        create(:like, user: user, post: post_obj)
        post :create, params: { post_id: post_obj.id }
        expect(flash[:notice]).to eq("You unliked this post.")
      end
    end
  end
end 