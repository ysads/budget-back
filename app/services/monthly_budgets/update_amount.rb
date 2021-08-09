# frozen_string_literal: true

module MonthlyBudgets
  class UpdateAmount < ApplicationService
    # INFO: amount_type describes the type of total being updated. It's either
    # :income or :activity
    def initialize(amount:, amount_type:, month:, monthly_budget: nil)
      @amount = amount
      @amount_type = amount_type
      @month = month
      @monthly_budget = monthly_budget
    end

    def call
      ActiveRecord::Base.transaction do
        update_monthly_budget
        update_month
      end
    end

    private

    attr_accessor :amount, :amount_type, :month, :monthly_budget

    def update_monthly_budget
      return if income?

      monthly_budget.update_attribute(
        amount_type, monthly_budget[amount_type] + amount
      )
    end
      
    def update_month
      month.update_attribute(amount_type, month[amount_type] + amount)

      if income?
        month.update_attribute(:to_be_budgeted, month.to_be_budgeted + amount)
      end
    end

    def income?
      amount_type == :income
    end
  end
end