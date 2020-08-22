# frozen_string_literal: true

class Budget < ApplicationRecord
  has_many :accounts, class_name: 'Account::Base'
  has_many :category_groups
  belongs_to :user

  validates :currency, :name, presence: true
end
