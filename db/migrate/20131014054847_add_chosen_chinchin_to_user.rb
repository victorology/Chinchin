class AddChosenChinchinToUser < ActiveRecord::Migration
  def change
    add_column :users, :chosen_chinchin, :text
  end
end
