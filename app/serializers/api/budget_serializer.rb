# frozen_string_literal: true

module Api
  class BudgetSerializer < ApplicationSerializer
    attributes :currency, :date_format, :name
  end
end
