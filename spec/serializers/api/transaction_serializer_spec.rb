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
          category_id: transaction.monthly_budget.category_id,
          cleared_at: transaction.cleared_at,
          memo: transaction.memo,
          monthly_budget_id: transaction.monthly_budget_id,
          account_id: transaction.account_id,
          outflow: transaction.outflow,
          payee_id: transaction.payee_id,
          payee_name: transaction.payee.name,
          reference_at: transaction.reference_at,
          unsigned_amount: transaction.unsigned_amount,
        },
        relationships: {
          monthly_budget: {
            data: {
              id: transaction.monthly_budget_id,
              type: :monthly_budget,
            },
          },
          account: {
            data: {
              id: transaction.account_id,
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

  context 'when the transaction has no associated monthly budget' do
    it 'features a nil category_id' do
      transaction = create(:transaction, monthly_budget: nil)

      result = described_class.new(transaction).serializable_hash

      expect(result).to include(
        data: hash_including(
          id: transaction.id,
          type: :transaction,
          attributes: hash_including(
            category_id: nil,
          ),
        ),
      )
    end
  end
end
