# frozen_string_literal: true

module Api
  class BudgetsController < ApplicationController
    before_action :authenticate_request!

    def create
      Budget.create!(permitted_params)

      head :ok
    end

    def index
      render json: Api::BudgetSerializer.new(available_budgets)
    end

    def show
      budget_board = available_budgets.find(params[:id])

      render json: Api::BudgetSerializer.new(budget_board)
    end

    private

    def available_budgets
      current_user.budgets
    end

    def permitted_params
      params.permit(:currency, :date_format, :name, :user_id)
    end
  end
end
