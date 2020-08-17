# frozen_string_literal: true

FactoryBot.define do
  ACCOUNT_CLASSES = [
    Account::Cash,
    Account::Checking,
    Account::Credit,
    Account::Savings,
    Account::Tracking,
  ].freeze

  factory :random_account, class: ACCOUNT_CLASSES.sample do
    sequence(:name) { |i| "Account #{i}" }
    cleared_balance { rand(1..1_000_000) }
    uncleared_balance { rand(1..1_000_000) }
    closed_at { nil }
    budget
  end
end
