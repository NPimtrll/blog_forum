class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: [ :mark_as_read ]

  def index
    @notifications = current_user.notifications.order(created_at: :desc).page(params[:page])
  end

  def mark_as_read
    @notification.update(read: true)
    redirect_back(fallback_location: root_path)
  end

  private

  def set_notification
    @notification = current_user.notifications.find(params[:id])
  end
end
