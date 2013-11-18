class AddAuthTokenAndAuthSecretToUser < ActiveRecord::Migration
  def change
    add_column :users, :auth_token, :string
    add_column :users, :auth_secret, :string
  end
end
