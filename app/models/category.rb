# frozen_string_literal: true

class Category < ApplicationRecord
  belongs_to :category_group

  validates :name, presence: true
end
