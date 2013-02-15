class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.references :chinchin
      t.references :user
      t.timestamps
    end
  end
end
