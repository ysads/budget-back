# frozen_string_literal: true

require 'rails_helper'

describe Api::MeSerializer do
  it 'serializes using json api' do
    user = create(:user)
    create(:budget, user: user)

    result = described_class.new(user).serializable_hash

    expect(result).to eq(
      data: {
        id: user.id,
        type: :me,
        attributes: {
          email: user.email,
          name: user.name,
          default_budget_id: user.budgets.first.id,
        },
      },
    )
  end

  context 'when user does not have a budget yet' do
    it 'serializes default_budget_id with nil' do
      user = create(:user)

      result = described_class.new(user).serializable_hash

      expect(result).to eq(
        data: {
          id: user.id,
          type: :me,
          attributes: {
            email: user.email,
            name: user.name,
            default_budget_id: nil,
          },
        },
      )
    end
  end
end
