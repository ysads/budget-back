# frozen_string_literal: true

module Transactions
  class UpdateTransfer < ApplicationUseCase
    def initialize(params)
      @params = params
      @origin_transaction = Transaction.find(params[:origin_transaction_id])
      @destination_transaction = Transaction.find(params[:destination_transaction_id])
    end

    def call
      ActiveRecord::Base.transaction do
        undo_budgeting
        undo_accounts_balance
        update_origin_transaction
        update_destination_transaction
        add_budgeting
        add_accounts_balance
        reload_objects

        [origin_transaction, destination_transaction]
      end
    end

    private

    attr_accessor :origin_transaction, :destination_transaction

    def undo_budgeting
      return if natures_match?

      amount_type = origin_transaction.monthly_budget.present? ? :activity : :income

      MonthlyBudgets::UpdateAmount.call(
        amount: -origin_transaction.amount,
        amount_type: amount_type,
        month: origin_transaction.month,
        monthly_budget: origin_transaction.monthly_budget,
      )
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

    def add_budgeting
      return if natures_match?

      amount_type = origin_transaction.monthly_budget.present? ? :activity : :income

      MonthlyBudgets::UpdateAmount.call(
        amount: params[:amount],
        amount_type: amount_type,
        month: origin_transaction.month,
        monthly_budget: origin_transaction.monthly_budget,
      )
    end

    def add_accounts_balance
      Accounts::UpdateBalance.call(
        account: origin_transaction.account,
        amount: origin_transaction.amount,
        cleared: origin_transaction.cleared?,
      )
      Accounts::UpdateBalance.call(
        account: destination_transaction.account,
        amount: destination_transaction.amount,
        cleared: destination_transaction.cleared?,
      )
    end

    def reload_objects
      origin_transaction.reload
      destination_transaction.reload
    end

    def natures_match?
      origin_transaction.account.nature === destination_transaction.account.nature
    end

    def spending?
      params[:type].to_sym == :spending
    end

    def update_origin_transaction
      origin_transaction.update!(
        amount: signed_amount,
        cleared_at: params[:cleared_at],
        account_id: params[:origin_id],
        outflow: true,
        memo: params[:memo],
        month: new_month,
        monthly_budget: new_monthly_budget,
        reference_at: params[:reference_at],
      )
    end

    def update_destination_transaction
      destination_transaction.update!(
        amount: -signed_amount,
        cleared_at: params[:cleared_at],
        account_id: params[:destination_id],
        outflow: false,
        memo: params[:memo],
        month: new_month,
        monthly_budget: new_monthly_budget,
        reference_at: params[:reference_at],
      )
    end

    def signed_amount
      -params[:amount]
    end

    def new_month
      @new_month ||= Months::FetchOrCreate.call(
        budget_id: params[:budget_id],
        iso_month: IsoMonth.of(params[:reference_at]),
      )
    end

    def new_monthly_budget
      return unless spending?

      @new_monthly_budget ||= ::MonthlyBudgets::FetchOrCreate.call(
        params: params.merge(month: new_month),
      )
    end
  end
end