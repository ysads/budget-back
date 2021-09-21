class AddLinkedTransactionId < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :linked_transaction_id, :uuid, null: true
    remove_column :transactions, :destination_id, :uuid
    rename_column :transactions, :origin_id, :account_id
  end
end
