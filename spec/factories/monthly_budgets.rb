# frozen_string_literal: true

FactoryBot.define do
  factory :monthly_budget do
    activity { rand(100_000) }
    budgeted { rand(100_000) }
    category
    month
  end
end
