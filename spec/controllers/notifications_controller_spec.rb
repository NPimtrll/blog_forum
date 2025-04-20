require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:notification) { create(:notification, user: user) }
  let(:other_notification) { create(:notification, user: other_user) }

  describe "GET #index" do
    context "when user is authenticated" do
      before do
        sign_in user
        get :index
      end
    end

    context "when user is not authenticated" do
      before { get :index }

      it "redirects to sign in" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH #mark_as_read" do
    context "when user is authenticated" do
      before do
        sign_in user
        patch :mark_as_read, params: { id: notification.id }
      end

      it "marks notification as read" do
        notification.reload
        expect(notification.read).to be true
      end
    end

    context "when user is not authenticated" do
      before { patch :mark_as_read, params: { id: notification.id } }

      it "redirects to sign in" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when notification belongs to another user" do
      before do
        sign_in user
      end

      it "raises not found error" do
        expect {
          patch :mark_as_read, params: { id: other_notification.id }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
