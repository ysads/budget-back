# frozen_string_literal: true

require 'rails_helper'

describe Months::AddIncome do
  let(:budget_id) { create(:budget).id }
  let(:iso_month) { Time.current.strftime('%Y-%m') }
  let(:amount) { rand(10_000) }

  it 'increases income and to_be_budgeted with amount' do
    month = create(
      :month, budget_id: budget_id, iso_month: Time.current.strftime('%Y-%m')
    )
    prev_income = month.income
    prev_to_be_budgeted = month.to_be_budgeted

    described_class.call(
      amount: amount,
      budget_id: budget_id,
      iso_month: iso_month,
    )

    expect(month.reload).to have_attributes(
      income: prev_income + amount,
      to_be_budgeted: prev_to_be_budgeted + amount,
    )
  end

  context 'when month does not exist' do
    it 'creates a new month', :aggregate_failures do
      expect do
        described_class.call(
          amount: amount,
          budget_id: budget_id,
          iso_month: iso_month,
        )
      end.to change { Month.count }.by(1)

      expect(Month.last).to have_attributes(
        activity: 0,
        budget_id: budget_id,
        budgeted: 0,
        iso_month: iso_month,
        income: amount,
        to_be_budgeted: amount,
      )
    end
  end
end
