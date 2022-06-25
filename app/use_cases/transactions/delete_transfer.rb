# frozen_string_literal: true

module Transactions
  class DeleteTransfer < ApplicationUseCase
    def initialize(params)
      @origin_transaction = Transaction.find(
        params[:origin_transaction_id],
      )
      @destination_transaction = Transaction.find(
        params[:destination_transaction_id],
      )
    end

    def call
      ActiveRecord::Base.transaction do
        undo_budgeting
        undo_accounts_balance
        delete_transactions
      end
    end

    private

    attr_accessor :destination_transaction, :origin_transaction

    def undo_budgeting
      return if natures_match?

      # FIXME: month's activity is positive... why?
      if origin_transaction.income?
        update_monthly_amounts(origin_transaction.amount)
      else
        update_monthly_amounts(destination_transaction.amount)
      end
    end

    def undo_accounts_balance
      Accounts::UpdateBalance.call(
        account: origin_transaction.account,
        amount: -origin_transaction.amount,
        cleared: origin_transaction.cleared?,
      )
      Accounts::UpdateBalance.call(
        account: destination_transaction.account,
        amount: -destination_transaction.amount,
        cleared: destination_transaction.cleared?,
      )
    end

    def delete_transactions
      destination_transaction.destroy!
      origin_transaction.destroy!
    end

    def update_monthly_amounts(amount)
      MonthlyBudgets::UpdateAmount.call(
        amount: amount,
        amount_type: amount_type,
        month: origin_transaction.month,
        monthly_budget: origin_transaction.monthly_budget,
      )
    end

    def amount_type
      return :income if origin_transaction.income?

      :activity
    end

    def natures_match?
      origin_transaction.account.nature ==
        destination_transaction.account.nature
    end
  end
end
