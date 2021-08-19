# frozen_string_literal: true

require 'rails_helper'

describe Accounts::UpdateBalance do
  context 'when transaction is cleared' do
    let(:account) { create(:random_account) }
    let(:amount) { rand(-50_000..50_000) }

    it 'updates cleared_balance' do
      prev_cleared_balance = account.cleared_balance

      described_class.call(account: account, amount: amount, cleared: true)

      expect(account.reload).to have_attributes(
        cleared_balance: prev_cleared_balance + amount,
      )
    end
  end

  context 'when transaction is not cleared' do
    let(:account) { create(:random_account) }
    let(:amount) { rand(-50_000..50_000) }

    it 'updates uncleared_balance' do
      prev_cleared_balance = account.uncleared_balance

      described_class.call(account: account, amount: amount, cleared: false)

      expect(account.reload).to have_attributes(
        uncleared_balance: prev_cleared_balance + amount,
      )
    end
  end
end
