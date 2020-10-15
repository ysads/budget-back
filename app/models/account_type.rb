# frozen_string_literal: true

class AccountType
  ALL = {
    'asset' => Account::Asset,
    'cash' => Account::Cash,
    'checking' => Account::Checking,
    'credit' => Account::Credit,
    'savings' => Account::Savings,
  }.freeze

  def self.all
    ALL.keys
  end

  def self.classes
    ALL.values
  end

  def self.class_of(type)
    ALL[type]
  end
end
