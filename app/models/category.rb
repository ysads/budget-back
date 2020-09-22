# frozen_string_literal: true

class Category < ApplicationRecord
  belongs_to :category_group
  has_many :monthly_budgets

  validates :name, presence: true
end
