class CreateProfilePhotos < ActiveRecord::Migration
  def change
    create_table :profile_photos do |t|
      t.integer :chinchin_id
      t.string :picture_url
      t.string :source_url
      t.integer :facebook_likes

      t.timestamps
    end
  end
end
