# frozen_string_literal: true

require 'rails_helper'

describe Api::TransactionSerializer do
  it 'serializes using json api' do
    transaction = create(:transaction)

    result = described_class.new(transaction).serializable_hash

    expect(result).to eq(
      data: {
        id: transaction.id,
        type: :transaction,
        attributes: {
          amount: transaction.amount,
          cleared_at: transaction.cleared_at,
          destination_id: transaction.destination_id,
          memo: transaction.memo,
          monthly_budget_id: transaction.monthly_budget_id,
          origin_id: transaction.origin_id,
          payee_id: transaction.payee_id,
          reference_at: transaction.reference_at,
        },
        relationships: {
          monthly_budget: {
            data: nil,
          },
          origin: {
            data: {
              id: transaction.origin_id,
              type: :account,
            },
          },
          payee: {
            data: {
              id: transaction.payee_id,
              type: :payee,
            },
          },
        },
      },
    )
  end
end