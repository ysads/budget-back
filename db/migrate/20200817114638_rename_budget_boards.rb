class RenameBudgetBoards < ActiveRecord::Migration[6.0]
  def self.up
    rename_table :budget_boards, :budgets
    rename_column :accounts, :budget_board_id, :budget_id
    rename_column :category_groups, :budget_board_id, :budget_id
  end

  def self.down
    rename_table :budgets, :budget_boards
    rename_column :accounts, :budget_id, :budget_board_id
    rename_column :category_groups, :budget_id, :budget_board_id
  end
end
