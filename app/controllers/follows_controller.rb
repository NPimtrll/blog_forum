class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:id])
    if current_user.following.exclude?(user)
      current_user.following << user
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    user = User.find(params[:id])
    current_user.following.delete(user)
    redirect_back(fallback_location: root_path)
  end
end
