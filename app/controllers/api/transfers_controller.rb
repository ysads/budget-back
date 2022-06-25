# frozen_string_literal: true

module Api
  class TransfersController < ApplicationController
    before_action :authenticate_request!
    before_action :authorize_budget!

    # POST /api/budgets/:budget_id/transfers
    def create
      transactions = Transfers::Create.call(create_params)

      render json: serialize(transactions)
    end

    # PUT /api/budgets/:budget_id/transfers
    def update
      transactions = Transactions::Update.call(update_params)

      render json: serialize(transactions)
    end

    # DELETE /api/budgets/:budget_id/transfers
    def destroy
      Transactions::Delete.call(destroy_params)

      head :ok
    end

    private

    def serialize(records)
      Api::TransactionSerializer.new(
        records, include: %i[monthly_budget account payee]
      )
    end

    def create_params
      params.permit(
        :amount, :budget_id, :category_id, :cleared_at, :destination_id,
        :id, :memo, :origin_id, :outflow, :reference_at, :type
      )
    end

    def update_params
      create_params.merge(
        params.permit(:destination_transaction_id, :origin_transaction_id),
      )
    end

    def destroy_params
      params.permit(:destination_transaction_id, :origin_transaction_id)
    end
  end
end
