class AddIsRecurringToCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :is_recurring, :boolean, default: false
  end
end
