class LikesController < ApplicationController
  before_action :authenticate_user!
  def create
    @post = Post.find(params[:post_id])
    like = @post.likes.find_or_initialize_by(user: current_user)

    if like.persisted?
      like.destroy
      message = "You unliked this post."
    else
      like.save
      message = "You liked this post."
    end

    redirect_to @post, notice: message
  end
end
