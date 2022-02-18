# frozen_string_literal: true

FactoryBot.define do
  factory :monthly_budget do
    activity { Faker::Number.within(range: -1_000_00..0) }
    budgeted { rand(100_000) }
    category
    month
  end
end
