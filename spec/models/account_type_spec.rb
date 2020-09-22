# frozen_string_literal: true

require 'rails_helper'

describe AccountType do
  describe '.all' do
    it do
      expect(described_class.all).to contain_exactly(
        'asset',
        'cash',
        'checking',
        'credit',
        'savings',
      )
    end
  end

  describe '.classes' do
    it do
      expect(described_class.classes).to contain_exactly(
        Account::Asset,
        Account::Cash,
        Account::Checking,
        Account::Credit,
        Account::Savings,
      )
    end
  end

  describe '.class_of' do
    it 'is the class associated to a particular type' do
      type = described_class.all.sample

      expect(described_class.class_of(type)).to eq(
        "Account::#{type.camelize}".constantize
      )
    end
  end
end
