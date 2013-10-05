class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.references :user
      t.integer :currency_type
      t.integer :max_count
      t.integer :current_count
      t.timestamps
    end
  end
end
