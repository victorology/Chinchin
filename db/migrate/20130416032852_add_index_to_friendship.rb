class AddIndexToFriendship < ActiveRecord::Migration
  def change
    add_index :friendships, [:user_id, :chinchin_id]
  end
end
