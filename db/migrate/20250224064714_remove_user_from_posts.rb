class RemoveUserFromPosts < ActiveRecord::Migration[8.0]
  def change
    remove_column :posts, :user, :string
  end
end
