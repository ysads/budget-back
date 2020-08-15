class CreateInitialTables < ActiveRecord::Migration[6.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :encrypted_password, null: false, default: ''
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.timestamps
    end

    create_table :budget_boards, id: :uuid do |t|
      t.string :name, null: false
      t.string :currency, null: false, default: 'USD'
      t.uuid :user_id, null: false
      t.timestamps
    end

    create_table :category_groups, id: :uuid do |t|
      t.string :name, null: false
      t.uuid :budget_board_id, null: false
      t.timestamps
    end

    create_table :categories, id: :uuid do |t|
      t.string :name, null: false
      t.uuid :category_group_id, null: false
      t.timestamps
    end

    create_table :months, id: :uuid do |t|
      t.datetime :month, null: false
      t.datetime :start_at, null: false
      t.datetime :finish_at, null: false
      t.integer :income, null: false, default: 0
      t.integer :activity, null: false, default: 0
      t.integer :budgeted, null: false, default: 0
      t.integer :to_be_budgeted, null: false, default: 0
      t.timestamps
    end

    create_table :monthly_budgets, id: :uuid do |t|
      t.uuid :category_id, null: false
      t.uuid :month_id, null: false
      t.integer :budgeted, null: false, default: 0
      t.integer :activity, null: false, default: 0
      t.timestamps
    end

    create_table :transactions, id: :uuid do |t|
      t.boolean :outflow, default: true
      t.text :memo, default: ''
      t.datetime :reference_at, null: false
      t.datetime :cleared_at
      t.integer :amount, null: false
      t.uuid :payee_id, null: false
      t.uuid :monthly_budget_id, null: false
      t.uuid :origin_id, null: false
      t.uuid :destination_id
      t.timestamps
    end

    create_table :payees, id: :uuid do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :accounts, id: :uuid do |t|
      t.string :type
      t.string :name, null: false
      t.datetime :closed_at
      t.integer :cleared_balance, null: false, default: 0
      t.integer :uncleared_balance, null: false, default: 0
      t.uuid :budget_board_id, null: false
      t.timestamps
    end
  end
end
