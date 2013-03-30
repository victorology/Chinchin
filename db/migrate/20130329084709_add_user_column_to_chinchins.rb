class AddUserColumnToChinchins < ActiveRecord::Migration
  def change
    add_column :chinchins, :user_id, :integer
  end
end
