require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_attributes) { { name: "Test Category" } }
  let(:invalid_attributes) { { name: "" } }

  describe 'GET #new' do
    context 'when user is not logged in' do
      it 'redirects to sign in page' do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is logged in' do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end

      it 'returns http success' do
        get :new
        expect(response).to have_http_status(:success)
      end

      it 'assigns a new category' do
        get :new
        expect(assigns(:category)).to be_a_new(Category)
      end

      it 'renders the new template' do
        get :new
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is not logged in' do
      it 'redirects to sign in page' do
        post :create, params: { category: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is logged in' do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      end

      context 'with valid parameters' do
        it 'creates a new category' do
          expect {
            post :create, params: { category: valid_attributes }
          }.to change(Category, :count).by(1)
        end

        it 'redirects to new post path with success message' do
          post :create, params: { category: valid_attributes }
          expect(response).to redirect_to(new_post_path)
          expect(flash[:notice]).to eq("Category was successfully created.")
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new category' do
          expect {
            post :create, params: { category: invalid_attributes }
          }.not_to change(Category, :count)
        end

        it 'renders the new template with unprocessable_entity status' do
          post :create, params: { category: invalid_attributes }
          expect(response).to render_template(:new)
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'assigns a new category with errors' do
          post :create, params: { category: invalid_attributes }
          expect(assigns(:category)).to be_a_new(Category)
          expect(assigns(:category).errors).not_to be_empty
        end
      end

      context 'with duplicate category name' do
        before { create(:category, name: "Test Category") }

        it 'does not create a new category' do
          expect {
            post :create, params: { category: valid_attributes }
          }.not_to change(Category, :count)
        end

        it 'renders the new template with unprocessable_entity status' do
          post :create, params: { category: valid_attributes }
          expect(response).to render_template(:new)
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'assigns a new category with uniqueness error' do
          post :create, params: { category: valid_attributes }
          expect(assigns(:category).errors[:name]).to include("has already been taken")
        end
      end
    end
  end
end 