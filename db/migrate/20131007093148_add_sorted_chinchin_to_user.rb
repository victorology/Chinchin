class AddSortedChinchinToUser < ActiveRecord::Migration
  def change
    add_column :users, :sorted_chinchin, :text
  end
end
