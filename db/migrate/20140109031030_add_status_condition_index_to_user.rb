class AddStatusConditionIndexToUser < ActiveRecord::Migration
  def change
    add_index :users, :status, where: "status = 1 or status = 5"
  end
end
