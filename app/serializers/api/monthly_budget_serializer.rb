# frozen_string_literal: true

module Api
  class MonthlyBudgetSerializer < ApplicationSerializer
    attributes :activity,
               :available,
               :budgeted,
               :category_id,
               :month_id

    attribute :category_group_id do |object|
      object.category.category_group_id
    end
  end
end
