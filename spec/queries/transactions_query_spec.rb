# frozen_string_literal: true

require 'rails_helper'

describe TransactionsQuery do
  before { freeze_time }
  after { travel_back }

  it 'filters by account id' do
    transaction = create(:transaction)
    create(:transaction)

    response = described_class.execute(account_id: transaction.account_id)

    expect(response).to contain_exactly(transaction)
  end

  it 'sorts records by latest reference_at, using created_at to untie' do
    transaction_1 = create(:transaction,
                           reference_at: 2.months.ago,
                           created_at: 20.days.ago)
    transaction_2 = create(:transaction,
                           reference_at: 2.days.ago,
                           created_at: 20.days.ago)
    transaction_3 = create(:transaction,
                           reference_at: 2.days.ago,
                           created_at: 10.days.ago)
    transaction_4 = create(:transaction,
                           reference_at: 2.weeks.ago,
                           created_at: 20.days.ago)

    response = described_class.execute

    expect(response).to eq(
      [transaction_3, transaction_2, transaction_4, transaction_1],
    )
  end
end
