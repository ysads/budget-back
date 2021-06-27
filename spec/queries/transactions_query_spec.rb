# frozen_string_literal: true

require 'rails_helper'

describe TransactionsQuery do
  it 'filters by origin id' do
    transaction = create(:transaction)
    create(:transaction)

    response = described_class.execute(origin_id: transaction.origin_id)

    expect(response).to contain_exactly(transaction)
  end
end
