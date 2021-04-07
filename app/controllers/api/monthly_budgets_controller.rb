# frozen_string_literal: true

module Api
  class MonthlyBudgetsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_budget!

    # POST /api/budgets/:budget_id/monthly_budgets/
    def index
      render json: MonthlyBudgetSerializer.new(available_monthly_budgets)
    end

    # POST /api/budgets/:budget_id/monthly_budgets/
    def create
      monthly_budget = MonthlyBudgets::Create.call(create_params)

      render json: MonthlyBudgetSerializer.new(monthly_budget)
    end

    # PUT /api/budgets/:budget_id/monthly_budgets/:id
    def update
      monthly_budget = MonthlyBudgets::Update.call(create_params)

      render json: MonthlyBudgetSerializer.new(monthly_budget)
    end

    private

    def available_monthly_budgets
      MonthlyBudgetsQuery.execute(index_params).includes(:category)
    end

    def index_params
      params.permit(:budget_id, :iso_month)
    end

    def create_params
      params.permit(:budgeted, :category_id, :id, :month_id)
    end
  end
end
