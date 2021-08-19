# frozen_string_literal: true

# FIXME: maybe merge it into Create class?
module MonthlyBudgets
  class FetchOrCreate < ApplicationService
    def initialize(params:)
      @params = params
    end

    def call
      monthly_budget || create_monthly_budget
    end

    private

    attr_reader :params

    def monthly_budget
      MonthlyBudget.find_by(
        month: params[:month],
        category_id: params[:category_id],
      )
    end

    def create_monthly_budget
      MonthlyBudgets::Create.call(
        budgeted: 0,
        budget_id: params[:budget_id],
        category_id: params[:category_id],
        month_id: params[:month].id,
      )
    end
  end
end
