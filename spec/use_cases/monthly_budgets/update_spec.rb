# frozen_string_literal: true

require 'rails_helper'

describe MonthlyBudgets::Update do
  let(:month) do
    create(:month, budgeted: 5_000, to_be_budgeted: 5_000, income: 10_000)
  end
  let(:monthly_budget) do
    create(:monthly_budget, budgeted: 5_000, month: month)
  end
  let(:params) do
    {
      budgeted: 3_000,
      category_id: monthly_budget.category_id,
      id: monthly_budget.id,
      month_id: monthly_budget.month_id,
    }
  end

  it 'updates the monthly budget' do
    monthly_budget = described_class.call(params)

    expect(monthly_budget).to have_attributes(budgeted: 3_000)
  end

  it 'updates the month budgeted amount' do
    described_class.call(params)
    
    expect(month.reload).to have_attributes(
      budgeted: 3_000,
      to_be_budgeted: 7_000,
    )
  end
end
