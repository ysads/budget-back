class AddIsoMonthToMonths < ActiveRecord::Migration[6.0]
  def change
    add_column :months, :iso_month, :string, null: false
    remove_column :months, :month, :string
    remove_column :months, :start_at, :datetime
    remove_column :months, :finish_at, :datetime
  end
end
