# frozen_string_literal: true

FactoryBot.define do
  factory :checking_account, class: Account::Checking do
    sequence(:name) { |i| "Checking Account #{i}" }
    cleared_balance { rand(1..1_000_000) }
    uncleared_balance { rand(1..1_000_000) }
    closed_at { nil }
    budget
  end

  factory :asset_account, class: Account::Asset do
    sequence(:name) { |i| "Asset Account #{i}" }
    cleared_balance { rand(1..1_000_000) }
    uncleared_balance { rand(1..1_000_000) }
    closed_at { nil }
    budget
  end

  factory :random_account, class: AccountType.classes.sample do
    sequence(:name) { |i| "Account #{i}" }
    cleared_balance { rand(1..1_000_000) }
    uncleared_balance { rand(1..1_000_000) }
    closed_at { nil }
    budget

    trait :with_type do
      transient do
        type { '' }
      end

      after(:create) do |account, evaluator|
        if evaluator.type.present?
          account.update!(
            type: "Account::#{evaluator.type.classify}".constantize,
          )
        end
      end
    end
  end
end
