# frozen_string_literal: true

class Month < ApplicationRecord
  has_many :budgets, through: :monthly_budgets

  validate :start_at,
           :finish_at,
           :income,
           :budgeted,
           :activity,
           :to_be_budgeted,
           presence: true
end
