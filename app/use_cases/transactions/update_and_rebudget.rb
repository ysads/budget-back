# frozen_string_literal: true

module Transactions
  class UpdateAndRebudget < ApplicationUseCase
    def initialize(params)
      @transaction = Transaction.find(params[:id])
      @params = params
    end

    def call
      ActiveRecord::Base.transaction do
        undo_previous_totals
        update_transaction
        add_new_totals

        # INFO: Needed to fetch relationships updated in other classes
        transaction.reload
      end
    end

    private

    attr_accessor :transaction

    def update_transaction
      @transaction = Transactions::Update.call(
        transaction: transaction,
        updated_params: params,
      )
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def undo_previous_totals
      amount_type = transaction.income? ? :income : :activity

      MonthlyBudgets::UpdateAmount.call(
        amount: -transaction.amount,
        amount_type: amount_type,
        month: transaction.month,
        monthly_budget: transaction.monthly_budget,
      )
      Accounts::UpdateBalance.call(
        account: transaction.account,
        amount: -transaction.amount,
        cleared: transaction.cleared?,
      )
    end

    def add_new_totals
      amount_type = transaction.income? ? :income : :activity

      MonthlyBudgets::UpdateAmount.call(
        amount: transaction.amount,
        amount_type: amount_type,
        month: transaction.month,
        monthly_budget: transaction.monthly_budget,
      )
      Accounts::UpdateBalance.call(
        account: transaction.account,
        amount: transaction.amount,
        cleared: transaction.cleared?,
      )
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
  end
end
