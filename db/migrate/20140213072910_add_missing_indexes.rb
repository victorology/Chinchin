class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :currencies, :user_id
    add_index :message_rooms, :user1_id
    add_index :message_rooms, :user2_id
    add_index :likes, :user_id
    add_index :likes, :chinchin_id
    add_index :messages, :message_room_id
    add_index :messages, :writer_id
    add_index :views, :viewer_id
    add_index :views, :viewee_id
    add_index :feeds, :user_id
    add_index :feeds, :target_user_id
    add_index :jumps, :user_id
    add_index :currency_logs, :currency_id
    add_index :chinchins, :user_id
    add_index :invitations, :user_id
    add_index :invitations, :chinchin_id
    add_index :currency_alarms, :currency_id
  end
end