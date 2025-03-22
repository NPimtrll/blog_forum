class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:following_id])
    if current_user.following.exclude?(user)
      current_user.following << user
    end
    render json: { following: true, followers_count: user.followers.count, following_count: current_user.following.count }
  end

  def destroy
    user = User.find(params[:following_id])
    current_user.following.delete(user)
    render json: { following: false, followers_count: user.followers.count, following_count: current_user.following.count }
  end
end
