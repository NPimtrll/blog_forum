require 'rails_helper'

RSpec.describe BookmarksController, type: :controller do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:post_obj) { create(:post, user: user, category: category) }

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

      it 'creates a new bookmark' do
        expect {
          post :create, params: { post_id: post_obj.id }
        }.to change(Bookmark, :count).by(1)
      end

      it 'redirects to post page' do
        post :create, params: { post_id: post_obj.id }
        expect(response).to redirect_to(post_obj)
      end

      it 'sets success message' do
        post :create, params: { post_id: post_obj.id }
        expect(flash[:notice]).to eq("Post bookmarked successfully")
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:bookmark) { create(:bookmark, user: user, post: post_obj) }

    context 'when user is not logged in' do
      it 'redirects to sign in page' do
        delete :destroy, params: { post_id: post_obj.id, id: bookmark.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is logged in' do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end

      it 'destroys the bookmark' do
        expect {
          delete :destroy, params: { post_id: post_obj.id, id: bookmark.id }
        }.to change(Bookmark, :count).by(-1)
      end

      it 'redirects to post page' do
        delete :destroy, params: { post_id: post_obj.id, id: bookmark.id }
        expect(response).to redirect_to(post_obj)
      end

      it 'sets success message' do
        delete :destroy, params: { post_id: post_obj.id, id: bookmark.id }
        expect(flash[:notice]).to eq("Post unbookmarked successfully")
      end
    end
  end

  describe 'GET #index' do
    context 'when user is not logged in' do
      it 'redirects to sign in page' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is logged in' do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end

      it 'displays bookmarked posts' do
        bookmark = create(:bookmark, user: user, post: post_obj)
        get :index
        expect(assigns(:bookmarked_posts)).to include(post_obj)
      end

      it 'displays empty state when no bookmarks' do
        get :index
        expect(assigns(:bookmarked_posts)).to be_empty
      end
    end
  end
end
