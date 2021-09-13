# frozen_string_literal: true

require 'rails_helper'

describe Transaction do
  describe 'relationships' do
    it { is_expected.to belong_to(:payee) }
    it { is_expected.to belong_to(:account).class_name('Account::Base') }
    it { is_expected.to belong_to(:monthly_budget).optional(true) }
    it { is_expected.to belong_to(:month) }
    it { is_expected.to belong_to(:linked_transaction).optional(true) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_presence_of(:reference_at) }
  end

  describe '#cleared?' do
    context 'when cleared_at is present' do
      subject { build(:transaction, cleared_at: DateTime.current) }

      it { expect(subject.cleared?).to eq(true) }
    end

    context 'when there is no cleared_at' do
      subject { build(:transaction, cleared_at: nil) }

      it { expect(subject.cleared?).to eq(false) }
    end
  end

  describe '#unsigned_amount' do
    it 'is the absolute value of amount', :aggregate_failures do
      expect(build(:transaction, amount: 300_00).unsigned_amount).to eq(300_00)
      expect(build(:transaction, amount: -300_00).unsigned_amount).to eq(300_00)
    end
  end

  describe '#income?' do
    context 'when monthly budget is missing' do
      subject { build(:transaction, monthly_budget_id: nil) }

      it { expect(subject.income?).to eq(true) }
    end

    context 'when monthly budget is present' do
      subject { build(:transaction, monthly_budget: build(:monthly_budget)) }

      it { expect(subject.income?).to eq(false) }
    end
  end
end
