# frozen_string_literal: true

FactoryBot.define do
  factory :category_group do
    budget
    name { Faker::Creature::Dog.name }
  end
end
