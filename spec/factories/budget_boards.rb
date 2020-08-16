# frozen_string_literal: true

FactoryBot.define do
  factory :budget_board do
    name { 'My Budget' }
    currency { 'BRL' }
    user
  end
end
