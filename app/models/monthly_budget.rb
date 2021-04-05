# frozen_string_literal: true

class MonthlyBudget < ApplicationRecord
  belongs_to :category
  belongs_to :month
  has_many :transactions

  def available
    budgeted - activity
  end
end
