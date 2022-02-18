# frozen_string_literal: true

class Month < ApplicationRecord
  belongs_to :budget
  has_many :monthly_budgets

  validates :iso_month,
            :income,
            :budgeted,
            :activity,
            :to_be_budgeted,
            presence: true

  validates :income, numericality: { greater_than_or_equal_to: 0 }
  validates :budgeted, numericality: { greater_than_or_equal_to: 0 }
  validates :activity, numericality: { less_than_or_equal_to: 0 }
end
