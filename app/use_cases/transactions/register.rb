# frozen_string_literal: true

module Transactions
  class Register < ApplicationUseCase
    def initialize(params)
      @params = params
    end

    def call
      ActiveRecord::Base.transaction do
        update_month
        create_transaction
        update_account_balance

        # INFO: Needed to fetch relationships updated in other classes
        transaction.reload
      end
    end

    private

    attr_accessor :month, :transaction

    def create_transaction
      @transaction = Transaction.create!(
        amount: signed_amount,
        cleared_at: params[:cleared_at],
        origin_id: params[:origin_id],
        outflow: params[:outflow],
        payee: payee,
        memo: params[:memo],
        monthly_budget: monthly_budget,
        reference_at: params[:reference_at],
      )
    end

    def update_month
      if income?
        add_income
      else
        add_activity
      end
    end

    def update_account_balance
      ::Accounts::UpdateBalance.call(
        account: origin_account,
        amount: transaction.amount,
        cleared: transaction.cleared?
      )
    end

    def add_income
      @month = Months::AddIncome.call(
        amount: params[:amount],
        budget_id: params[:budget_id],
        iso_month: IsoMonth.of(params[:reference_at]),
      )
    end

    def add_activity
      @month = Months::AddActivity.call(
        amount: params[:amount],
        budget_id: params[:budget_id],
        category_id: params[:category_id],
        iso_month: IsoMonth.of(params[:reference_at]),
      )
    end

    def income?
      params[:category_id].blank?
    end

    def signed_amount
      return params[:amount] unless params[:outflow]

      -params[:amount]
    end

    def payee
      @payee ||= Payee.find_or_create_by!(
        budget_id: params[:budget_id],
        name: params[:payee_name],
      )
    end

    def monthly_budget
      @monthly_budget ||= month.monthly_budgets.find_by(
        category_id: params[:category_id],
      )
    end

    def origin_account
      @origin_account ||= ::Account::Base.find(params[:origin_id])
    end
  end
end
