require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post) }
  let(:comment) { create(:comment) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:notifiable) }
  end

  describe 'scopes' do
    let!(:read_notification) { create(:notification, user: user, read: true) }
    let!(:unread_notification) { create(:notification, user: user, read: false) }

    describe '.unread' do
      it 'returns only unread notifications' do
        expect(Notification.unread).to include(unread_notification)
        expect(Notification.unread).not_to include(read_notification)
      end
    end

    describe '.recent' do
      it 'returns notifications ordered by created_at desc' do
        # Clear existing notifications
        Notification.destroy_all

        # Create notifications with specific timestamps
        travel_to 2.days.ago do
          @old_notification = create(:notification, user: user)
        end

        travel_to 1.day.ago do
          @new_notification = create(:notification, user: user)
        end

        expect(Notification.recent.first).to eq(@new_notification)
        expect(Notification.recent.last).to eq(@old_notification)
      end
    end
  end

  describe '.create_for_mention' do
    context 'when mentioning in a post' do
      it 'creates a notification for the mentioned user' do
        expect {
          Notification.create_for_mention(user, post, "#{user.username} mentioned you in their post: #{post.title}")
        }.to change(Notification, :count).by(1)
      end

      it 'creates notification with correct attributes' do
        notification = Notification.create_for_mention(user, post, "#{user.username} mentioned you in their post: #{post.title}")

        expect(notification.user).to eq(user)
        expect(notification.notifiable).to eq(post)
        expect(notification.read).to be_falsey
      end
    end

    context 'when mentioning in a comment' do
      it 'creates a notification for the mentioned user' do
        expect {
          Notification.create_for_mention(user, comment, "#{user.username} mentioned you in a comment on: #{comment.post.title}")
        }.to change(Notification, :count).by(1)
      end

      it 'creates notification with correct attributes' do
        notification = Notification.create_for_mention(user, comment, "#{user.username} mentioned you in a comment on: #{comment.post.title}")

        expect(notification.user).to eq(user)
        expect(notification.notifiable).to eq(comment)
        expect(notification.read).to be_falsey
      end
    end
  end

  describe 'callbacks' do
    it 'broadcasts notification after creation' do
      expect(ActionCable.server).to receive(:broadcast).with(
        "notification_channel_#{user.id}",
        hash_including(:html)
      )

      Notification.create_for_mention(user, post, "#{user.username} mentioned you in their post: #{post.title}")
    end
  end
end
