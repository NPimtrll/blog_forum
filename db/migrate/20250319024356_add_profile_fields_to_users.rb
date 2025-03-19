class AddProfileFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :about_me, :text
    add_column :users, :twitter_url, :string
    add_column :users, :linkedin_url, :string
    add_column :users, :github_url, :string
    add_column :users, :email_notifications, :boolean, default: true, null: false
    add_column :users, :profile_privacy, :boolean, default: true, null: false
  end
end
