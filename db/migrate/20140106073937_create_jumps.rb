class CreateJumps < ActiveRecord::Migration
  def change
    create_table :jumps do |t|
      t.references :user
      t.integer :from
      t.integer :to
      t.timestamps
    end
  end
end
