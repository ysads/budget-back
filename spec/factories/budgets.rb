# frozen_string_literal: true

FactoryBot.define do
  factory :budget do
    name { 'My Budget' }
    currency { 'BRL' }
    user
  end
end
