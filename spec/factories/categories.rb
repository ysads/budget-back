# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    category_group
    name { Faker::Creature::Dog.name }
  end
end
