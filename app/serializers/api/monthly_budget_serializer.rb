# frozen_string_literal: true

module Api
  class MonthlyBudgetSerializer < ApplicationSerializer
    attributes :activity,
               :budgeted,
               :category_id,
               :month_id
  end
end
