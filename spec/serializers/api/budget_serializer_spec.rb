# frozen_string_literal: true

require 'rails_helper'

describe Api::BudgetSerializer do
  it 'serializes using json api' do
    budget = create(:budget)

    result = described_class.new(budget).serializable_hash

    expect(result).to eq(
      data: {
        id: budget.id,
        type: :budget,
        attributes: {
          currency: budget.currency,
          name: budget.name
        }
      }
    )
  end
end
