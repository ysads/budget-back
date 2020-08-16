# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "user_#{i}@mail.com" }

    name { 'John' }
    password { 'my@pass123' }
  end
end
