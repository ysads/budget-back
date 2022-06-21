# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "user_#{i}@mail.com" }
    sequence(:auth_provider_id) { |i| "token_#{i}" }

    name { 'John' }
  end
end
