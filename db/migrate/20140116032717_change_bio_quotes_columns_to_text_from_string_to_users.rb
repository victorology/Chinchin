class ChangeBioQuotesColumnsToTextFromStringToUsers < ActiveRecord::Migration
  def up
    change_column :users, :bio, :text
    change_column :users, :quotes, :text
  end
  def down
    change_column :users, :bio, :string
    change_column :users, :quotes, :string
  end
end
