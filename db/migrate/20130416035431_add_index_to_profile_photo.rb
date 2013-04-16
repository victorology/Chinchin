class AddIndexToProfilePhoto < ActiveRecord::Migration
  def change
    add_index :profile_photos, :chinchin_id
  end
end
