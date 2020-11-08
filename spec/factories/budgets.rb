# frozen_string_literal: true

FactoryBot.define do
  factory :budget do
    currency { 'BRL' }
    date_format { 'dd-MM-YYYY' }
    name { 'My Budget' }
    user
  end
end
