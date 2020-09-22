class RemoveNotNullFromMonthlyBudget < ActiveRecord::Migration[6.0]
  def change
    change_column_null :transactions, :monthly_budget_id, true
  end
end