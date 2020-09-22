# frozen_string_literal: true

require 'rails_helper'

describe Api::AccountSerializer do
  it 'serializes using json api' do
    account = create(:random_account)
    account_type = account.type.split('::').last.downcase

    result = described_class.new(account).serializable_hash

    expect(result).to eq(
      data: {
        id: account.id,
        type: :account,
        attributes: {
          balance: account.balance,
          cleared_balance: account.cleared_balance,
          closed_at: account.closed_at,
          name: account.name,
          nature: account.nature,
          uncleared_balance: account.uncleared_balance,
          type: account_type
        }
      }
    )
  end
end
