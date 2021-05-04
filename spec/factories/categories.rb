# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    category_group
    name { Faker::Creature::Dog.name }

    trait :with_budget do
      transient do
        budget { create(:budget) }
      end

      after(:create) do |category, evaluator|
        category.category_group.update!(
          budget: evaluator.budget,
        )
      end
    end
  end
end
