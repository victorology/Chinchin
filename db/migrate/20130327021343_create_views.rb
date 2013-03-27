class CreateViews < ActiveRecord::Migration
  def change
    create_table :views do |t|
      t.references :viewer
      t.references :viewee

      t.timestamps
    end
  end
end
