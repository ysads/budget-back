class AddBudgetIdToMonth < ActiveRecord::Migration[6.0]
  def change
    add_column :months, :budget_id, :uuid, index: true
    add_foreign_key :months, :budgets
  end
end
