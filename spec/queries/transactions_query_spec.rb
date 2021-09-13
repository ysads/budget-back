# frozen_string_literal: true

require 'rails_helper'

describe TransactionsQuery do
  it 'filters by account id' do
    transaction = create(:transaction)
    create(:transaction)

    response = described_class.execute(account_id: transaction.account_id)

    expect(response).to contain_exactly(transaction)
  end

  it 'sorts records from newest to oldest' do
    transaction_1 = create(:transaction, created_at: 2.months.ago)
    transaction_2 = create(:transaction, created_at: 2.days.ago)
    transaction_3 = create(:transaction, created_at: 2.weeks.ago)

    response = described_class.execute

    expect(response).to eq([transaction_2, transaction_3, transaction_1])
  end
end
