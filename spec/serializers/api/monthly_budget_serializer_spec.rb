# frozen_string_literal: true

require 'rails_helper'

describe Api::MonthlyBudgetSerializer do
  it 'serializes using json api' do
    monthly_budget = create(:monthly_budget)

    result = described_class.new(monthly_budget).serializable_hash

    expect(result).to eq(
      data: {
        id: monthly_budget.id,
        type: :monthly_budget,
        attributes: {
          activity: monthly_budget.activity,
          available: monthly_budget.available,
          budgeted: monthly_budget.budgeted,
          category_id: monthly_budget.category_id,
          category_group_id: monthly_budget.category.category_group_id,
          month_id: monthly_budget.month_id,
        },
      },
    )
  end
end
