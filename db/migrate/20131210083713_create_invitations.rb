class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :chinchin
      t.references :user
      t.string :via
      t.timestamps
    end
  end
end
