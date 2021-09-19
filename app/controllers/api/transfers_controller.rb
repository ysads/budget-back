# frozen_string_literal: true

module Api
  class TransfersController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_budget!

    # POST /api/budgets/:budget_id/transfers
    def create
      transactions = Transactions::CreateTransfer.call(create_params)

      render json: serialize(transactions)
    end

    private

    def serialize(records)
      Api::TransactionSerializer.new(
        records, include: %i[monthly_budget account payee]
      )
    end

    def create_params
      params.permit(
        :amount, :budget_id, :category_id, :destination_id, :id,
        :memo, :origin_id, :outflow, :reference_at, :type
      )
    end
  end
end