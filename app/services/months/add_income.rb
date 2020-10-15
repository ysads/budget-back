# frozen_string_literal: true

module Months
  class AddIncome < ApplicationService
    def initialize(amount:, budget_id:, iso_month:)
      @amount = amount
      @budget_id = budget_id
      @iso_month = iso_month
    end

    def call
      ActiveRecord::Base.transaction do
        find_or_create_month
        update_income
      end
    end

    private

    attr_accessor :amount, :budget_id, :iso_month

    def find_or_create_month
      @month = Month.find_or_create_by!(iso_month: iso_month)
    end

    def update_income
      @month.update(
        income: @month.income + amount,
        to_be_budgeted: @month.to_be_budgeted + amount,
      )
    end
  end
end
