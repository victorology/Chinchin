class CreateCurrencyLogs < ActiveRecord::Migration
  def change
    create_table :currency_logs do |t|
      t.references :currency
      t.string :action
      t.integer :value
      t.timestamps
    end
  end
end
