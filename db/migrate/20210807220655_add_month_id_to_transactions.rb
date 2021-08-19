class AddMonthIdToTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :month_id, :uuid, index: true
    add_foreign_key :transactions, :months
  end
end
