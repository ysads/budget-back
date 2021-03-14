# frozen_string_literal: true

module Api
  class MonthlyBudgetsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_budget!

    # POST /api/budgets/:budget_id/monthly_budgets/
    def create
      monthly_budget = MonthlyBudgets::Create.call(permitted_params)

      render json: MonthlyBudgetSerializer.new(monthly_budget)
    end

    private

    def permitted_params
      params.permit(:budgeted, :category_id, :month_id)
    end
  end
end
