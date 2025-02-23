class LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    existing_like = @post.likes.find_by(user: current_user)

    if existing_like
      existing_like.destroy
    else
      @post.likes.create(user: current_user)
    end

    redirect_to @post, notice: "You liked this post."
  end
end
