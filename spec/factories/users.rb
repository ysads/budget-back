# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'John' }
    email { 'john@mail.com' }
    password { 'my@pass123' }
  end
end
