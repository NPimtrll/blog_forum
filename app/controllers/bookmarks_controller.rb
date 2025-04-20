class BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bookmark, only: [ :destroy ]

  def index
    @bookmarked_posts = current_user.bookmarked_posts.includes(:user, :category).order(created_at: :desc)
  end

  def create
    @post = Post.find(params[:post_id])
    @bookmark = current_user.bookmarks.build(post: @post)

    if @bookmark.save
      respond_to do |format|
        format.html { redirect_to @post, notice: "Post bookmarked successfully" }
      end
    else
      respond_to do |format|
        format.html { redirect_to @post, alert: "Failed to bookmark post" }
      end
    end
  end

  def destroy
    @post = @bookmark.post
    @bookmark.destroy

    respond_to do |format|
      format.html { redirect_to @post, notice: "Post unbookmarked successfully" }
    end
  end

  private

  def set_bookmark
    @bookmark = current_user.bookmarks.find(params[:id])
  end
end
