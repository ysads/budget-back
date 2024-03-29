# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :validatable

  has_many :budgets
end
