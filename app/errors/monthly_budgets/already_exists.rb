# frozen_string_literal: true

module MonthlyBudgets
  class AlreadyExists < ApplicationError
    def code
      'monthly-budgets/already-exists'
    end

    def message
      'There category already has a budget for this month'
    end
  end
end
