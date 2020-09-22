# frozen_string_literal: true

class Payee < ApplicationRecord
  belongs_to :budget
  has_many :transactions

  validates :name, presence: true
end
