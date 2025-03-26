class BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:create, :destroy]

  def index
    @bookmarked_posts = current_user.bookmarked_posts.includes(:user, :category).order(created_at: :desc)
  end

  def create
    @bookmark = current_user.bookmarks.build(post: @post)

    respond_to do |format|
      if @bookmark.save
        format.html { redirect_back(fallback_location: root_path, notice: 'Post was successfully bookmarked.') }
        format.json { render json: { status: :created } }
      else
        format.html { redirect_back(fallback_location: root_path, alert: 'Could not bookmark the post.') }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @bookmark = current_user.bookmarks.find_by(post: @post)
    @bookmark.destroy if @bookmark

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path, notice: 'Bookmark was successfully removed.') }
      format.json { head :no_content }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end 