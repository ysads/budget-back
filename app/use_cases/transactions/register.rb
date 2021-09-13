# frozen_string_literal: true

module Transactions
  class Register < ApplicationUseCase
    def initialize(params)
      @params = params
    end

    def call
      ActiveRecord::Base.transaction do
        create_transaction
        update_month
        update_account_balance

        # INFO: Needed to fetch relationships updated in other classes
        transaction.reload
      end
    end

    private

    attr_accessor :transaction

    # rubocop:disable Metrics/MethodLength
    def create_transaction
      @transaction = Transaction.create!(
        amount: signed_amount,
        cleared_at: params[:cleared_at],
        account_id: params[:account_id],
        outflow: params[:outflow],
        payee: payee,
        memo: params[:memo],
        month: month,
        monthly_budget: monthly_budget,
        reference_at: params[:reference_at],
      )
    end
    # rubocop:enable Metrics/MethodLength

    def update_month
      amount_type = income? ? :income : :activity

      MonthlyBudgets::UpdateAmount.call(
        amount: signed_amount,
        amount_type: amount_type,
        month: month,
        monthly_budget: monthly_budget,
      )
    end

    def update_account_balance
      ::Accounts::UpdateBalance.call(
        account: account,
        amount: transaction.amount,
        cleared: transaction.cleared?,
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

    def month
      @month ||= Months::FetchOrCreate.call(
        budget_id: params[:budget_id],
        iso_month: IsoMonth.of(params[:reference_at]),
      )
    end

    def monthly_budget
      return if income?

      @monthly_budget ||= ::MonthlyBudgets::FetchOrCreate.call(
        params: params.merge(month: month),
      )
    end

    def account
      @account ||= ::Account::Base.find(params[:account_id])
    end
  end
end
