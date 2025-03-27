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
        format.html { redirect_to @post, notice: "บันทึกโพสต์เรียบร้อยแล้ว" }
      end
    else
      respond_to do |format|
        format.html { redirect_to @post, alert: "ไม่สามารถบันทึกโพสต์ได้" }
      end
    end
  end

  def destroy
    @post = @bookmark.post
    @bookmark.destroy

    respond_to do |format|
      format.html { redirect_to @post, notice: "ลบการบันทึกโพสต์เรียบร้อยแล้ว" }
    end
  end

  private

  def set_bookmark
    @bookmark = current_user.bookmarks.find(params[:id])
  end
end
