class UsersController < ApplicationController
  before_action :set_user, only: [ :edit, :update, :show ]
  before_action :authenticate_user!, only: [ :edit, :update ]

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "อัปเดตโปรไฟล์สำเร็จ!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :avatar)
  end
end
