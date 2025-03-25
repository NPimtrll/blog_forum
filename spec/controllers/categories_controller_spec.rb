require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  describe 'GET #new' do
    it 'redirects to sign in page' do
      get :new
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'POST #create' do
    it 'redirects to sign in page' do
      post :create, params: { category: { name: "Test Category" } }
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end 