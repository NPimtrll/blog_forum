class AddForeignKeyToPosts < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :posts, :users, column: :user_id
  end
end
