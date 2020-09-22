# frozen_string_literal: true

class Month < ApplicationRecord
  has_many :monthly_budgets

  validates :iso_month,
            :income,
            :budgeted,
            :activity,
            :to_be_budgeted,
            presence: true
end
