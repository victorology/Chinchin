class CreateMessageRooms < ActiveRecord::Migration
  def change
    create_table :message_rooms do |t|
      t.references :user1
      t.references :user2
      t.string :title
      t.integer :status
      t.timestamps
    end
  end
end
