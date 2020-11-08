class AddDateFormatToBudget < ActiveRecord::Migration[6.0]
  def change
    add_column :budgets, :date_format, :string
  end
end
