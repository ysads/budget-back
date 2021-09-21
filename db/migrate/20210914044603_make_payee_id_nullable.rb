class MakePayeeIdNullable < ActiveRecord::Migration[6.1]
  def change
    change_column_null :transactions, :payee_id, true
  end
end
