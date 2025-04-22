require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:post_obj) { create(:post, user: user) }
  let(:valid_attributes) { { content: "Test comment" } }
  let(:invalid_attributes) { { content: "" } }

  describe 'POST #create' do
    context 'when user is not logged in' do
      it 'redirects to sign in page' do
        post :create, params: { post_id: post_obj.id, comment: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is logged in' do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end

      it 'creates a new comment' do
        expect {
          post :create, params: { post_id: post_obj.id, comment: valid_attributes }
        }.to change(Comment, :count).by(1)
      end

      it 'redirects to post page' do
        post :create, params: { post_id: post_obj.id, comment: valid_attributes }
        expect(response).to redirect_to("#{post_path(post_obj)}#comment-#{Comment.last.id}")
      end

      it 'fails to create with invalid attributes' do
        post :create, params: { post_id: post_obj.id, comment: invalid_attributes }
        expect(response).to redirect_to(post_obj)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'PATCH #update' do
    let(:comment) { create(:comment, user: user, post: post_obj) }

    context 'when user is not logged in' do
      it 'redirects to sign in page' do
        patch :update, params: { post_id: post_obj.id, id: comment.id, comment: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is logged in' do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end

      it 'updates the comment' do
        patch :update, params: { post_id: post_obj.id, id: comment.id, comment: { content: "Updated content" } }
        expect(comment.reload.content).to eq("Updated content")
      end

      it 'redirects to post page' do
        patch :update, params: { post_id: post_obj.id, id: comment.id, comment: valid_attributes }
        expect(response).to redirect_to(post_obj)
      end

      it 'fails to update with invalid attributes' do
        patch :update, params: { post_id: post_obj.id, id: comment.id, comment: invalid_attributes }
        expect(response).to redirect_to(post_obj)
        expect(flash[:alert]).to be_present
      end
    end

    context 'when user is not the comment owner' do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in other_user
      end

      it 'redirects to post page with error' do
        patch :update, params: { post_id: post_obj.id, id: comment.id, comment: valid_attributes }
        expect(response).to redirect_to(post_obj)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:comment) { create(:comment, user: user, post: post_obj) }

    context 'when user is not logged in' do
      it 'redirects to sign in page' do
        delete :destroy, params: { post_id: post_obj.id, id: comment.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is logged in' do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end

      it 'deletes the comment' do
        expect {
          delete :destroy, params: { post_id: post_obj.id, id: comment.id }
        }.to change(Comment, :count).by(-1)
      end

      it 'redirects to post page' do
        delete :destroy, params: { post_id: post_obj.id, id: comment.id }
        expect(response).to redirect_to(post_obj)
      end
    end

    context 'when user is not the comment owner' do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in other_user
      end

      it 'redirects to post page with error' do
        delete :destroy, params: { post_id: post_obj.id, id: comment.id }
        expect(response).to redirect_to(post_obj)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'GET #edit' do
    let(:comment) { create(:comment, user: user, post: post_obj) }

    context 'when user is not logged in' do
      it 'redirects to sign in page' do
        get :edit, params: { post_id: post_obj.id, id: comment.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is logged in' do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end

      it 'renders edit template' do
        get :edit, params: { post_id: post_obj.id, id: comment.id }
        expect(response).to be_successful
        expect(assigns(:comment)).to eq(comment)
      end
    end

    context 'when user is not the comment owner' do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in other_user
      end

      it 'redirects to post page with error' do
        get :edit, params: { post_id: post_obj.id, id: comment.id }
        expect(response).to redirect_to(post_obj)
        expect(flash[:alert]).to be_present
      end
    end
  end
end
