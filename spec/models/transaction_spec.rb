# frozen_string_literal: true

require 'rails_helper'

describe Transaction do
  describe 'relationships' do
    it { is_expected.to belong_to(:payee) }
    it { is_expected.to belong_to(:origin).class_name('Account::Base') }
    it { is_expected.to belong_to(:monthly_budget).optional(true) }
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
end
