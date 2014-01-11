class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :user
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :email
      t.string :facebook_uid
      t.string :facebook_username
      t.string :twitter_username

      t.timestamps
    end

    add_index :contacts, :user_id
    add_index :contacts, :phone_number
    add_index :contacts, :facebook_uid
  end
end
