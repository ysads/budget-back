# frozen_string_literal: true

FactoryBot.define do
  factory :checking_account, class: Account::Checking do
    sequence(:name) { |i| "Checking Account #{i}" }
    cleared_balance { rand(1..1_000_000) }
    uncleared_balance { rand(1..1_000_000) }
    closed_at { nil }
    budget_board
  end
end
