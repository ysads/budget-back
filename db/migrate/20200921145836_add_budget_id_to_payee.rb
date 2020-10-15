class AddBudgetIdToPayee < ActiveRecord::Migration[6.0]
  def change
    add_column :payees, :budget_id, :uuid
    add_foreign_key :payees, :budgets
  end
end
