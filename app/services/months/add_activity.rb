# frozen_string_literal: true

module Months
  class AddActivity < ApplicationService
    def initialize(amount:, budget_id:, category_id:, iso_month:)
      @amount = amount
      @category_id = category_id
      @budget_id = budget_id
      @iso_month = iso_month
    end

    def call
      ActiveRecord::Base.transaction do
        find_or_create_month
        find_or_create_monthly_budget
        update_activity
        update_month
        month
      end
    end

    private

    attr_accessor :month, :monthly_budget

    def find_or_create_month
      @month = Months::FetchOrCreate.call(
        budget_id: @budget_id,
        iso_month: @iso_month,
      )
    end

    def find_or_create_monthly_budget
      @monthly_budget = existing_monthly_budget || MonthlyBudgets::Create.call(
        budgeted: 0,
        category_id: @category_id,
        month_id: month.id,
      )
    end

    def update_activity
      monthly_budget.update!(
        activity: monthly_budget.activity + @amount,
      )
    end

    def update_month
      month.update!(
        activity: month.activity + @amount,
      )
    end

    def existing_monthly_budget
      month.monthly_budgets.find_by(category_id: @category_id)
    end
  end
end
