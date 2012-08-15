class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :birthday
      t.string :location
      t.string :hometown
      t.string :employer
      t.string :position
      t.string :gender
      t.string :relationship_status
      t.string :school
      t.string :locale
      t.string :oauth_token
      t.datetime :oauth_expires_at

      t.timestamps
    end
  end
end
