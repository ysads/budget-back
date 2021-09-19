# frozen_string_literal: true

module Transactions
  class CreateTransfer < ApplicationUseCase
    def initialize(params)
      @params = params
    end

    def call
      ActiveRecord::Base.transaction do
        create_origin_transaction
        create_destination_transaction
        link_transactions
        update_accounts_balance
        update_month
        reload_objects

        [origin_transaction, destination_transaction]
      end
    end

    private

    attr_accessor :origin_transaction, :destination_transaction

    def create_origin_transaction
      @origin_transaction = Transaction.create!(
        amount: signed_amount,
        cleared_at: params[:cleared_at],
        account_id: params[:origin_id],
        outflow: params[:outflow],
        memo: params[:memo],
        month: month,
        monthly_budget: monthly_budget,
        reference_at: params[:reference_at],
      )
    end

    def create_destination_transaction
      @destination_transaction = Transaction.create!(
        amount: -signed_amount,
        cleared_at: params[:cleared_at],
        account_id: params[:destination_id],
        outflow: !params[:outflow],
        memo: params[:memo],
        month: month,
        monthly_budget: monthly_budget,
        reference_at: params[:reference_at],
      )
    end

    def update_accounts_balance
      ::Accounts::UpdateBalance.call(
        account: origin_transaction.account,
        amount: origin_transaction.amount,
        cleared: origin_transaction.cleared?,
      )
      ::Accounts::UpdateBalance.call(
        account: destination_transaction.account,
        amount: destination_transaction.amount,
        cleared: destination_transaction.cleared?,
      )
    end

    def link_transactions
      origin_transaction.update!(
        linked_transaction_id: destination_transaction.id
      )
      destination_transaction.update!(
        linked_transaction_id: origin_transaction.id
      )
    end

    def update_month
      return if rebalance?

      amount_type = spending? ? :activity : :income

      MonthlyBudgets::UpdateAmount.call(
        amount: signed_amount,
        amount_type: amount_type,
        month: month,
        monthly_budget: monthly_budget,
      )
    end

    def reload_objects
      origin_transaction.reload
      destination_transaction.reload
    end

    def signed_amount
      -params[:amount]
    end

    def month
      @month ||= Months::FetchOrCreate.call(
        budget_id: params[:budget_id],
        iso_month: IsoMonth.of(params[:reference_at]),
      )
    end

    def monthly_budget
      return unless spending?

      @monthly_budget ||= ::MonthlyBudgets::FetchOrCreate.call(
        params: params.merge(month: month),
      )
    end

    def spending?
      params[:type].to_sym == :spending
    end

    def rebalance?
      params[:type].to_sym == :rebalance
    end
  end
end