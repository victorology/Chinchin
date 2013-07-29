class CreateTempChinchins < ActiveRecord::Migration
  def change
    create_table :temp_chinchins do |t|
      t.integer :chinchin_id
      t.integer :user_id
      t.timestamps
    end
  end
end
