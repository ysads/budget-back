# frozen_string_literal: true

# FIXME: move me into update
module Transactions
  class Update < ApplicationService
    def initialize(transaction:, updated_params:)
      @transaction = transaction
      @params = updated_params
    end

    def call
      transaction.update!(updated_params)
      transaction
    end

    private

    attr_accessor :transaction, :params

    # rubocop:disable Metrics/MethodLength
    def updated_params
      {
        amount: signed_amount,
        cleared_at: params[:cleared_at],
        account_id: params[:account_id],
        outflow: params[:outflow],
        payee: payee,
        memo: params[:memo],
        month: month,
        monthly_budget: monthly_budget,
        reference_at: params[:reference_at],
      }
    end
    # rubocop:enable Metrics/MethodLength

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
  end
end
