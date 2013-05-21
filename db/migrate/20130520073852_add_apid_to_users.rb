class AddApidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :apid, :string
  end
end
