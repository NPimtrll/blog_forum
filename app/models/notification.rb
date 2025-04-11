class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc) }

  after_create_commit :broadcast_notification

  def self.create_for_mention(user, notifiable, message)
    create!(
      user: user,
      notifiable: notifiable,
      message: message,
      read: false
    )
  end

  private

  def broadcast_notification
    ActionCable.server.broadcast(
      "notification_channel_#{user.id}",
      {
        html: ApplicationController.renderer.render(
          partial: "notifications/notification",
          locals: { notification: self },
          format: :html
        )
      }
    )
  end
end
