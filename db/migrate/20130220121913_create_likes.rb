class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :chinchin
      t.references :user
      t.timestamps
    end
  end
end
