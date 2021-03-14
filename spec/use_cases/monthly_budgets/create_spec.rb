# frozen_string_literal: true

require 'rails_helper'

describe MonthlyBudgets::Create do
  let(:params) do
    {
      budgeted: 0,
      category_id: create(:category).id,
      month_id: create(:month).id,
    }
  end

  it 'creates a new monthly budget' do
    month = described_class.call(params)

    expect(month).to have_attributes(
      **params,
      activity: 0,
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
