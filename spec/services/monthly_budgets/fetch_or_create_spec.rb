# frozen_string_literal: true

require 'rails_helper'

describe MonthlyBudgets::FetchOrCreate do
  let(:month) { create(:month) }
  let(:params) do
    {
      budget_id: month.budget_id,
      category_id: create(:category).id,
      month: month,
    }
  end

  context "when there's a record with that category and month" do
    it 'returns the existing record' do
      monthly_budget = create(
        :monthly_budget, category_id: params[:category_id], month: month
      )

      expect(described_class.call(params: params)).to eq(monthly_budget)
    end
  end

  context '' do
    it 'creates a new monthly budget' do
      expect do
        described_class.call(params: params)
      end.to change { MonthlyBudget.count }.by(1)
    end
  end
end
