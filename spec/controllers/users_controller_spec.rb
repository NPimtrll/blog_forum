require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:success)
    end

    it 'assigns the requested user' do
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end

    it 'assigns posts count' do
      create_list(:post, 3, user: user)
      get :show, params: { id: user.id }
      expect(assigns(:posts_count)).to eq(3)
    end

    it 'assigns total views' do
      create(:post, user: user, views: 10)
      create(:post, user: user, views: 20)
      get :show, params: { id: user.id }
      expect(assigns(:total_views)).to eq(30)
    end

    it 'assigns ordered posts' do
      post1 = create(:post, user: user, created_at: 1.day.ago)
      post2 = create(:post, user: user, created_at: 2.days.ago)
      get :show, params: { id: user.id }
      expect(assigns(:all_posts)).to eq([post1, post2])
    end
  end

  describe 'GET #edit' do
    context 'when user is logged in' do
      before { sign_in user }

      it 'returns http success for own profile' do
        get :edit, params: { id: user.id }
        expect(response).to have_http_status(:success)
      end

      it 'redirects to root path when trying to edit other user profile' do
        get :edit, params: { id: other_user.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("คุณไม่มีสิทธิ์แก้ไขโปรไฟล์ของผู้ใช้อื่น")
      end
    end

    context 'when user is not logged in' do
      it 'redirects to sign in page' do
        get :edit, params: { id: user.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is logged in' do
      before { sign_in user }

      it 'updates user profile successfully' do
        patch :update, params: { id: user.id, user: { username: 'new_username', full_name: 'New Name' } }
        expect(response).to redirect_to(user)
        user.reload
        expect(user.username).to eq('new_username')
        expect(user.full_name).to eq('New Name')
      end

      it 'does not update email' do
        old_email = user.email
        patch :update, params: { id: user.id, user: { email: 'new@email.com' } }
        user.reload
        expect(user.email).to eq(old_email)
      end

      it 'renders edit template when update fails' do
        allow_any_instance_of(User).to receive(:update).and_return(false)
        patch :update, params: { id: user.id, user: { username: 'new_username' } }
        expect(response).to render_template(:edit)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to sign in page' do
        patch :update, params: { id: user.id, user: { username: 'new_username' } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end 