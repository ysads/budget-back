# frozen_string_literal: true

module Api
  class BudgetBoardSerializer < ApplicationSerializer
    attributes :currency, :name
  end
end
