# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :payee
  belongs_to :monthly_budget

  validates :amount, :reference_at, :outflow, presence: true
end
