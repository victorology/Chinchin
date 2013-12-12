class AddViaToCurrencyLog < ActiveRecord::Migration
  def change
    add_column :currency_logs, :via, :string
  end
end
