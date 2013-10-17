class CreateCurrencyAlarms < ActiveRecord::Migration
  def change
    create_table :currency_alarms do |t|
      t.references :currency
      t.integer :alarm_type
      t.integer :status
      t.datetime :set_at
      t.timestamps
    end
  end
end
