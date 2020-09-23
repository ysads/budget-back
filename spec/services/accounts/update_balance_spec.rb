# frozen_string_literal: true

require 'rails_helper'

describe Accounts::UpdateBalance do
  context 'when transaction is cleared' do
    let(:account) { create(:random_account) }
    let(:transaction) { create(:transaction) }

    it 'updates cleared_balance' do
      prev_cleared_balance = account.cleared_balance

      described_class.call(account: account, transaction: transaction)

      expect(account.reload).to have_attributes(
        cleared_balance: prev_cleared_balance + transaction.amount,
      )
    end
  end

  context 'when transaction is not cleared' do
    let(:account) { create(:random_account) }
    let(:transaction) { create(:transaction, :uncleared) }

    it 'updates uncleared_balance' do
      prev_cleared_balance = account.uncleared_balance

      described_class.call(account: account, transaction: transaction)

      expect(account.reload).to have_attributes(
        uncleared_balance: prev_cleared_balance + transaction.amount,
      )
    end
  end
end
