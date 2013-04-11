class AddPhotoCountToChinchins < ActiveRecord::Migration
  def change
    add_column :chinchins, :photo_count, :integer
  end
end
