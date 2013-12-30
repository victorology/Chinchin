class AddBioAndQuotesAndRegisteredAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bio, :string
    add_column :users, :quotes, :string
    add_column :users, :registered_at, :datetime
  end
end
