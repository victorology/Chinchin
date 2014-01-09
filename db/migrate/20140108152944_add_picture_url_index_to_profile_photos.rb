class AddPictureUrlIndexToProfilePhotos < ActiveRecord::Migration
  def change
    add_index :profile_photos, :picture_url
  end
end
