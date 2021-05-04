# frozen_string_literal: true

module Api
  class TransactionsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_budget!

    def create
      transaction = Transactions::Register.call(create_params)

      render json: Api::TransactionSerializer.new(
        transaction,
        include: %i[monthly_budget origin payee],
      )
    end

    private

    def create_params
      params.permit(
        :amount, :budget_id, :cleared_at, :category_id,
        :memo, :origin_id, :outflow, :payee_name, :reference_at,
      )
    end
  end
end
