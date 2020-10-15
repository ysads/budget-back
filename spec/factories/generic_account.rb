# frozen_string_literal: true

FactoryBot.define do
  factory :random_account, class: AccountType.classes.sample do
    sequence(:name) { |i| "Account #{i}" }
    cleared_balance { rand(1..1_000_000) }
    uncleared_balance { rand(1..1_000_000) }
    closed_at { nil }
    budget
  end
end
