require 'rails_helper'

RSpec.describe BookmarksController, type: :controller do
  let(:user) { create(:user) }
  let(:post) { create(:post) }

  before do
    login_as user
  end

  describe 'authentication' do
    it 'requires user to be logged in' do
      logout
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
