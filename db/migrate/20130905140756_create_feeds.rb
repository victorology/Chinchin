class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
    	t.string :feed_type
    	t.string :message
    	t.references :user
    	t.references :target_user
      t.timestamps
    end
  end
end
