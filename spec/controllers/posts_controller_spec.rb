require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:valid_attributes) {
    {
      title: "Test Post",
      content: "Test Content",
      excerpt: "Test Excerpt",
      category_id: category.id,
      tag_names: [ "tag1", "tag2" ]
    }
  }

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'assigns popular posts' do
      popular_post = create(:post, views: 100)
      get :index
      expect(assigns(:popular_posts)).to include(popular_post)
    end

    context 'with filter' do
      it 'filters posts by today' do
        today_post = create(:post, created_at: Time.zone.now)
        old_post = create(:post, created_at: 2.days.ago)
        get :index, params: { filter: 'today' }
        expect(assigns(:latest_posts)).to include(today_post)
        expect(assigns(:latest_posts)).not_to include(old_post)
      end
    end
  end

  describe 'GET #show' do
    let(:post) { create(:post) }

    it 'returns http success' do
      get :show, params: { id: post.id }
      expect(response).to have_http_status(:success)
    end

    it 'increments view count' do
      expect {
        get :show, params: { id: post.id }
      }.to change { post.reload.views }.by(1)
    end
  end

  describe 'GET #new' do
    context 'when user is logged in' do
      before { sign_in user }

      it 'returns http success' do
        get :new
        expect(response).to have_http_status(:success)
      end

      it 'assigns a new post' do
        get :new
        expect(assigns(:post)).to be_a_new(Post)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to sign in page' do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is logged in' do
      before { sign_in user }

      it 'creates a new post' do
        expect {
          post :create, params: { post: valid_attributes }
        }.to change(Post, :count).by(1)
      end

      it 'creates tags for the post' do
        post :create, params: { post: valid_attributes }
        expect(Post.last.tags.map(&:name)).to match_array([ "tag1", "tag2" ])
      end

      it 'redirects to the created post' do
        post :create, params: { post: valid_attributes }
        expect(response).to redirect_to(Post.last)
      end
    end
  end

  describe 'GET #edit' do
    let(:post) { create(:post, user: user) }

    context 'when user is logged in' do
      before { sign_in user }

      it 'returns http success for own post' do
        get :edit, params: { id: post.id }
        expect(response).to have_http_status(:success)
      end

      it 'redirects to root for other user post' do
        other_post = create(:post)
        get :edit, params: { id: other_post.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PATCH #update' do
    let(:post) { create(:post, user: user) }
    let(:new_attributes) { { title: "Updated Title" } }

    context 'when user is logged in' do
      before { sign_in user }

      it 'updates the post' do
        patch :update, params: { id: post.id, post: new_attributes }
        post.reload
        expect(post.title).to eq("Updated Title")
      end

      it 'redirects to the post' do
        patch :update, params: { id: post.id, post: new_attributes }
        expect(response).to redirect_to(post)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:post) { create(:post, user: user) }

    context 'when user is logged in' do
      before { sign_in user }

      it 'destroys the post' do
        expect {
          delete :destroy, params: { id: post.id }
        }.to change(Post, :count).by(-1)
      end

      it 'redirects to posts index' do
        delete :destroy, params: { id: post.id }
        expect(response).to redirect_to(posts_path)
      end
    end
  end

  describe 'GET #popular' do
    it 'returns http success' do
      get :popular
      expect(response).to have_http_status(:success)
    end

    it 'orders posts by views' do
      post1 = create(:post, views: 10)
      post2 = create(:post, views: 20)
      get :popular
      expect(assigns(:posts)).to eq([ post2, post1 ])
    end
  end

  describe 'GET #latest' do
    context 'when user is logged in' do
      before { sign_in user }

      it 'returns http success' do
        get :latest
        expect(response).to have_http_status(:success)
      end

      it 'orders posts by creation date' do
        post1 = create(:post, created_at: 1.day.ago)
        post2 = create(:post, created_at: Time.current)
        get :latest
        expect(assigns(:posts)).to eq([ post2, post1 ])
      end
    end

    context 'when user is not logged in' do
      it 'redirects to sign in page' do
        get :latest
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #tagged' do
    let(:tag) { create(:tag) }
    let!(:tagged_post) { create(:post) }

    before do
      tagged_post.tags << tag
    end

    context 'when user is logged in' do
      before { sign_in user }

      it 'returns http success' do
        get :tagged, params: { tag_id: tag.id }
        expect(response).to have_http_status(:success)
      end

      it 'assigns tagged posts' do
        get :tagged, params: { tag_id: tag.id }
        expect(assigns(:posts)).to include(tagged_post)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to sign in page' do
        get :tagged, params: { tag_id: tag.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
