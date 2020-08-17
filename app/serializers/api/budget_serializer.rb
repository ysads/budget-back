# frozen_string_literal: true

module Api
  class BudgetSerializer < ApplicationSerializer
    attributes :currency, :name
  end
end
