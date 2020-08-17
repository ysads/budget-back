# frozen_string_literal: true

FactoryBot.define do
  factory :tracking_account, class: Account::Tracking do
    sequence(:name) { |i| "Tracking Account #{i}" }
    cleared_balance { rand(1..1_000_000) }
    uncleared_balance { rand(1..1_000_000) }
    closed_at { nil }
    budget
  end
end
