# frozen_string_literal: true

require 'rails_helper'

describe Months::AddActivity do
  let(:budget_id) { create(:budget).id }
  let(:iso_month) { IsoMonth.of(Time.current) }
  let(:amount) { rand(10_000) }
  let(:category) { create(:category) }

  it "updates the activity attribute in category's monthly budget" do
    month = create(:month, budget_id: budget_id, iso_month: iso_month)
    monthly_budget = create(:monthly_budget, category: category, month: month)
    prev_activity = monthly_budget.activity

    described_class.call(
      amount: amount,
      budget_id: budget_id,
      category_id: category.id,
      iso_month: iso_month,
    )

    expect(monthly_budget.reload.activity).to eq(prev_activity + amount)
  end

  it 'updates the month activity' do
    month = create(:month, budget_id: budget_id, iso_month: iso_month)
    prev_activity = month.activity

    described_class.call(
      amount: amount,
      budget_id: budget_id,
      category_id: category.id,
      iso_month: iso_month,
    )

    expect(month.reload.activity).to eq(prev_activity + amount)
  end

  it 'returns the updated month' do
    month = create(:month, budget_id: budget_id, iso_month: iso_month)
    response = described_class.call(
      amount: amount,
      budget_id: budget_id,
      category_id: category.id,
      iso_month: iso_month,
    )

    expect(response).to eq(month.reload)
  end

  describe 'when there is no monthly budget for the category' do
    it 'creates a new record' do
      expect do
        described_class.call(
          amount: amount,
          budget_id: budget_id,
          category_id: category.id,
          iso_month: iso_month,
        )
      end.to change { MonthlyBudget.count }.by(1)
    end
  end

  describe 'when there is no month matching iso_month' do
    it 'creates a new record' do
      expect do
        described_class.call(
          amount: amount,
          budget_id: budget_id,
          category_id: category.id,
          iso_month: IsoMonth.of(2.months.from_now),
        )
      end.to change { Month.count }.by(1)
    end
  end

  describe 'when there is no monthly budget for the category' do
    it 'creates a new record' do
      expect do
        described_class.call(
          amount: amount,
          budget_id: budget_id,
          category_id: category.id,
          iso_month: iso_month,
        )
      end.to change { MonthlyBudget.count }.by(1)
    end
  end
end
