# frozen_string_literal: true

require 'rails_helper'

describe MonthlyBudgets::Create do
  let(:month) do
    create(:month, budgeted: 0, to_be_budgeted: 50_00, income: 50_00)
  end
  let(:params) do
    {
      budgeted: 4_000,
      category_id: create(:category).id,
      month_id: month.id,
    }
  end

  it 'creates a new monthly budget' do
    month = described_class.call(params)

    expect(month).to have_attributes(
      **params,
      activity: 0,
    )
  end

  it 'moves money from to_be_budgeted to budgeted' do
    described_class.call(params)
    
    expect(month.reload).to have_attributes(
      budgeted: 40_00,
      to_be_budgeted: 10_00,
      income: 50_00,
    )
  end

  context 'when already exists a monthly budget on this month and category' do
    it 'raises MonthlyBudgets::AlreadyExists' do
      create(:monthly_budget,
             category_id: params[:category_id],
             month_id: params[:month_id])

      expect do
        described_class.call(params)
      end.to raise_error(MonthlyBudgets::AlreadyExists)
    end

    it 'does not create a new month' do
      create(:monthly_budget,
             category_id: params[:category_id],
             month_id: params[:month_id])

      expect do
        described_class.call(params)
      end.to(
        raise_error(MonthlyBudgets::AlreadyExists).and(
          not_change { MonthlyBudget.count },
        ),
      )
    end
  end
end
