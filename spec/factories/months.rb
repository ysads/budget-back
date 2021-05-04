# frozen_string_literal: true

FactoryBot.define do
  factory :month do
    iso_month do
      IsoMonth.of(Faker::Date.between(from: 2.years.ago, to: Date.today))
    end
    activity { rand(100_000) }
    budgeted { rand(100_000) }
    budget
    income { rand(100_000) }
    to_be_budgeted { rand(10_000) }
  end
end
