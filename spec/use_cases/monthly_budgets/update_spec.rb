# frozen_string_literal: true

require 'rails_helper'

describe MonthlyBudgets::Update do
  let(:monthly_budget) { create(:monthly_budget, budgeted: 5_000) }
  let(:month) { monthly_budget.month }
  let(:params) do
    {
      budgeted: 3_000,
      category_id: monthly_budget.category_id,
      id: monthly_budget.id,
      month_id: monthly_budget.month_id,
    }
  end

  it 'updates the monthly budget' do
    month = described_class.call(params)

    expect(month).to have_attributes(budgeted: 3_000)
  end

  it 'updates the month budgeted amount' do
    expect do
      described_class.call(params)
    end.to change { month.reload.budgeted }.by(-2_000)
  end
end
