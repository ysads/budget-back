# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    amount { rand(-100_000..100_000) }
    cleared_at { DateTime.current }
    origin { create(:random_account) }
    payee
    reference_at { Faker::Date.between(from: 1.month.ago, to: Date.current) }

    trait :uncleared do
      cleared_at { nil }
    end
  end
end
