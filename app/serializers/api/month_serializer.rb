# frozen_string_literal: true

module Api
  class MonthSerializer < ApplicationSerializer
    attributes :activity,
               :budgeted,
               :income,
               :iso_month,
               :to_be_budgeted
  end
end
