# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    amount { rand(-100_000..100_000) }
    cleared_at { DateTime.current }
    account { create(:random_account) }
    reference_at { Faker::Date.between(from: 1.month.ago, to: Date.current) }

    month
    monthly_budget
    payee

    trait :uncleared do
      cleared_at { nil }
    end

    trait :with_linked_transaction do
      linked_transaction { create(:transaction) }
    end
  end
end
