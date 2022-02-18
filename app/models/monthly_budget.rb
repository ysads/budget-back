# frozen_string_literal: true

class MonthlyBudget < ApplicationRecord
  belongs_to :category
  belongs_to :month
  has_many :transactions

  validates :budgeted, numericality: { greater_than_or_equal_to: 0 }
  validates :activity, numericality: { less_than_or_equal_to: 0 }

  def available
    budgeted + activity
  end
end
