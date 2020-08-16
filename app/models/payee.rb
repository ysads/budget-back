# frozen_string_literal: true

class Payee < ApplicationRecord
  has_many :transactions

  validates :name, presence: true
end
