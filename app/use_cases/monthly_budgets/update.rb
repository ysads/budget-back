# frozen_string_literal: true

module MonthlyBudgets
  class Update < ApplicationUseCase
    def initialize(params)
      @params = params
      @monthly_budget = MonthlyBudget.find(params[:id])
      @previous_budgeted = @monthly_budget.budgeted
    end

    def call
      update_monthly_budget
      update_month
      monthly_budget
    end

    private

    attr_accessor :monthly_budget, :previous_budgeted

    def updated_budgeted
      month.budgeted - previous_budgeted + monthly_budget.budgeted
    end

    def updated_to_be_budgeted
      month.to_be_budgeted + previous_budgeted - monthly_budget.budgeted
    end

    def update_month
      month.update!(
        budgeted: updated_budgeted,
        to_be_budgeted: updated_to_be_budgeted,
      )
    end

    def update_monthly_budget
      monthly_budget.update!(budgeted: params[:budgeted])
    end

    def month
      @month ||= monthly_budget.month
    end
  end
end
