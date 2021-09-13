# frozen_string_literal: true

module Api
  class TransactionsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_budget!

    # POST /api/budgets/:budget_id/transactions
    def create
      transaction = Transactions::Register.call(create_params)

      render json: serialize(transaction)
    end

    # GET /api/budgets/:budget_id/transactions
    def index
      transactions = TransactionsQuery.execute(index_params)

      render json: Api::TransactionSerializer.new(transactions)
    end

    # PUT /api/budgets/:budget_id/transactions/:id
    def update
      transaction = Transactions::UpdateAndRebudget.call(create_params)

      render json: serialize(transaction)
    end

    private

    def serialize(records)
      Api::TransactionSerializer.new(
        records, include: %i[monthly_budget account payee]
      )
    end

    def create_params
      params.permit(
        :amount, :budget_id, :cleared_at, :category_id, :id,
        :memo, :account_id, :outflow, :payee_name, :reference_at
      )
    end

    def index_params
      params.permit(:account_id)
    end
  end
end
