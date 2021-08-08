# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :payee
  belongs_to :origin, class_name: 'Account::Base'
  belongs_to :monthly_budget, optional: true
  belongs_to :month

  validates :amount, :reference_at, presence: true

  def cleared?
    cleared_at.present?
  end
end
