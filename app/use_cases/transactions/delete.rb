# frozen_string_literal: true

module Transactions
  class Delete < ApplicationUseCase
    def initialize(params)
      @transaction = Transaction.find(params[:id])
      @params = params
    end

    def call
      ActiveRecord::Base.transaction do
        undo_budgeting
        update_account_balance
        delete_transaction
      end
    end

    private

    attr_accessor :transaction

    def undo_budgeting
      amount_type = transaction.income? ? :income : :activity

      MonthlyBudgets::UpdateAmount.call(
        amount: -transaction.amount,
        amount_type: amount_type,
        month: transaction.month,
        monthly_budget: transaction.monthly_budget,
      )
    end

    def update_account_balance
      Accounts::UpdateBalance.call(
        account: transaction.account,
        amount: -transaction.amount,
        cleared: transaction.cleared?,
      )
    end

    def delete_transaction
      transaction.destroy!
    end
  end
end
