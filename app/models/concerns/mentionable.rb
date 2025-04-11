module Mentionable
  extend ActiveSupport::Concern

  included do
    after_create :notify_mentioned_users
  end

  private

  def notify_mentioned_users
    mentioned_usernames = content.scan(/@(\w+)/).flatten
    return if mentioned_usernames.empty?

    mentioned_usernames.each do |username|
      user = User.find_by(username: username)
      next unless user

      message = case self
      when Post
                  "#{self.user.username} mentioned you in their post: #{title}"
      when Comment
                  "#{self.user.username} mentioned you in a comment on: #{post.title}"
      end

      Notification.create_for_mention(user, self, message)
    end
  end
end
