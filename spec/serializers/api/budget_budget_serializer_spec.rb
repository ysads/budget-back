# frozen_string_literal: true

require 'rails_helper'

describe Api::BudgetBoardSerializer do
  it 'serializes using json api' do
    budget_board = create(:budget_board)

    result = described_class.new(budget_board).serializable_hash

    expect(result).to eq(
      data: {
        id: budget_board.id,
        type: :budget_board,
        attributes: {
          currency: budget_board.currency,
          name: budget_board.name
        }
      }
    )
  end
end
