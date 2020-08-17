# frozen_string_literal: true

class CategoryGroup < ApplicationRecord
  has_many :categories
  belongs_to :budget

  validates :name, presence: true
end
