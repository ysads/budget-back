# frozen_string_literal: true

FactoryBot.define do
  factory :month do
    iso_month do
      IsoMonth.of(Faker::Date.between(from: 2.years.ago, to: Date.today))
    end
    activity { Faker::Number.within(range: -1_000_00..0) }
    budgeted { rand(1_000_00) }
    budget
    income { rand(1_000_00) }
    to_be_budgeted { rand(100_00) }
  end
end
