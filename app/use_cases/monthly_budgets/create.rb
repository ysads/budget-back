# frozen_string_literal: true

module MonthlyBudgets
  class Create < ApplicationUseCase
    def initialize(params)
      @params = params
    end

    def call
      raise MonthlyBudgets::AlreadyExists if already_exists?

      ::MonthlyBudget.create!(
        activity: 0,
        budgeted: params[:budgeted],
        category_id: params[:category_id],
        month_id: params[:month_id],
      )
    end

    private

    def already_exists?
      MonthlyBudget.exists?(
        category_id: params[:category_id],
        month_id: params[:month_id],
      )
    end
  end
end
