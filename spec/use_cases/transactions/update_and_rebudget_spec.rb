# frozen_string_literal: true

require 'rails_helper'

describe Transactions::UpdateAndRebudget do
  let(:new_reference) { DateTime.current.iso8601 }
  let(:budget) { create(:budget) }
  let(:month) do
    create(:month, iso_month: IsoMonth.of(new_reference), budget: budget)
  end
  let(:new_payee) { create(:payee, budget: budget) }
  let(:old_payee) { create(:payee, budget: budget) }
  let(:new_monthly_budget) { create(:monthly_budget, month: month) }
  let(:old_monthly_budget) { create(:monthly_budget, month: month) }
  let(:transaction) do
    create(
      :transaction,
      monthly_budget: old_monthly_budget,
      payee: old_payee,
      cleared_at: Time.current.iso8601,
      reference_at: 1.day.ago,
    )
  end
  let!(:params) do
    {
      amount: Faker::Number.between(from: 1, to: 1000),
      budget_id: budget.id,
      category_id: new_monthly_budget.category_id,
      cleared_at: nil,
      id: transaction.id,
      memo: Faker::Lorem.sentence,
      origin_id: transaction.origin_id,
      outflow: true,
      payee_name: new_payee.name,
      reference_at: new_reference,
    }
  end

  before { freeze_time }
  after { travel_back }

  it 'updates transaction attributes', :aggregate_failures do
    expect do
      described_class.call(params)
    end.not_to change { Transaction.count }

    expect(Transaction.last).to have_attributes(
      cleared_at: nil,
      memo: params[:memo],
      origin_id: params[:origin_id],
      outflow: params[:outflow],
      payee: new_payee,
      monthly_budget: new_monthly_budget,
      reference_at: DateTime.parse(params[:reference_at]),
    )
  end
end
