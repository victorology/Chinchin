class ChangeStatusConditionIndexToUsers < ActiveRecord::Migration
  def change
    remove_index :users, :status
    add_index :users, :status, where: "status > 0"
  end
end
