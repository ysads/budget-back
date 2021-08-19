# frozen_string_literal: true

module MonthlyBudgets
  class Create < ApplicationUseCase
    def initialize(params)
      @params = params
    end

    def call
      raise MonthlyBudgets::AlreadyExists if already_exists?

      create_monthly_budget
      update_month
      monthly_budget
    end

    private

    attr_accessor :monthly_budget

    def create_monthly_budget
      @monthly_budget = ::MonthlyBudget.create!(
        activity: 0,
        budgeted: params[:budgeted],
        category_id: params[:category_id],
        month_id: params[:month_id],
      )
    end

    def update_month
      month.update!(
        budgeted: month.budgeted + monthly_budget.budgeted,
        to_be_budgeted: month.to_be_budgeted - monthly_budget.budgeted,
      )
    end

    def already_exists?
      MonthlyBudget.exists?(
        category_id: params[:category_id],
        month_id: params[:month_id],
      )
    end

    def month
      @month ||= Month.find(params[:month_id])
    end
  end
end
