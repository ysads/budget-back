# frozen_string_literal: true

FactoryBot.define do
  factory :asset_account, class: Account::Asset do
    sequence(:name) { |i| "Asset Account #{i}" }
    cleared_balance { rand(1..1_000_000) }
    uncleared_balance { rand(1..1_000_000) }
    closed_at { nil }
    budget
  end
end
