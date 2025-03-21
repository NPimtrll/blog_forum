class UsersController < ApplicationController
  before_action :set_user, only: [ :edit, :update, :show ]
  before_action :authenticate_user!, only: [ :edit, :update ]

  def show
    @posts_count = @user.posts.count
    @total_views = @user.posts.sum(:views)
    @all_posts = @user.posts.order(created_at: :desc)
  end

  def edit
    # ตรวจสอบว่าผู้ใช้กำลังแก้ไขโปรไฟล์ตัวเอง
    unless @user == current_user
      redirect_to root_path, alert: "คุณไม่มีสิทธิ์แก้ไขโปรไฟล์ของผู้ใช้อื่น"
    end
  end

  def update
    # ป้องกันไม่ให้ผู้ใช้แก้ไข email โดยตรง
    filtered_params = user_params.except(:email)

    if @user.update(filtered_params)
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
    params.require(:user).permit(:username, :full_name, :avatar, :about_me,
                                 :twitter_url, :linkedin_url, :github_url,
                                 :email_notifications, :profile_privacy, :role)
  end
end
