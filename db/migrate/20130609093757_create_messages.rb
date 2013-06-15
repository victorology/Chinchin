class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :message_room
      t.references :writer
      t.integer :type
      t.string :content
      t.timestamps
    end
  end
end
