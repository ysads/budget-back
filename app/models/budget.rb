# frozen_string_literal: true

class Budget < ApplicationRecord
  belongs_to :category
  has_many :months, through: :monthly_budgets

  validates :amount, :reference_at, :outflow, presence: true
end
