# frozen_string_literal: true

require 'rails_helper'

describe Transactions::CreateTransfer do
  let(:budget) { create(:budget) }
  let(:category_id) { create(:category, :with_budget, budget: budget).id }
  let(:origin_account) { create(:checking_account) }
  let(:destination_account) { create(:checking_account) }
  let(:transfer_type) { :rebalance }
  let(:params) do
    {
      amount: Faker::Number.between(from: 1, to: 1000),
      budget_id: budget.id,
      category_id: category_id,
      cleared_at: Time.current.iso8601,
      destination_id: destination_account.id,
      memo: Faker::Lorem.sentence,
      origin_id: origin_account.id,
      outflow: true,
      type: transfer_type,
      reference_at: Time.current.iso8601,
    }
  end

  before { freeze_time }
  after { travel_back }

  it 'creates an outbound transaction on origin account' do
    transactions = described_class.call(params)

    expect(transactions.first).to have_attributes(
      outflow: true,
      account_id: origin_account.id,
      amount: -params[:amount],
    )
  end

  it 'creates an inbound transaction on destination account' do
    transactions = described_class.call(params)

    expect(transactions.last).to have_attributes(
      outflow: false,
      account_id: destination_account.id,
      amount: params[:amount],
    )
  end

  it 'links both transactions together', :aggregate_failures do
    transactions = described_class.call(params)

    expect(transactions.first.linked_transaction).to eq(transactions.last)
    expect(transactions.last.linked_transaction).to eq(transactions.first)
  end

  it 'updates origin account balance' do
    expect do
      described_class.call(params)
    end.to change { origin_account.reload.cleared_balance }.by(-params[:amount])
  end

  it 'updates destination account balance' do
    expect do
      described_class.call(params)
    end.to(
      change { destination_account.reload.cleared_balance }.by(params[:amount]),
    )
  end

  it 'does not change monthly budgets for :rebalance transfers' do
    allow(MonthlyBudgets::UpdateAmount).to receive(:call)

    described_class.call(params)

    expect(MonthlyBudgets::UpdateAmount).not_to have_received(:call)
  end

  context 'when transfer is a :income' do
    let(:origin_account) { create(:asset_account) }
    let(:destination_account) { create(:checking_account) }
    let(:transfer_type) { :income }

    it "updates month's income" do
      allow(MonthlyBudgets::UpdateAmount).to receive(:call)

      described_class.call(params)

      expect(MonthlyBudgets::UpdateAmount).to have_received(:call).with(
        hash_including(
          amount: params[:amount],
          amount_type: :income,
        ),
      )
    end
  end

  context 'when transfer is a :spending' do
    let(:origin_account) { create(:checking_account) }
    let(:destination_account) { create(:asset_account) }
    let(:transfer_type) { :spending }

    it "updates month's income" do
      allow(MonthlyBudgets::UpdateAmount).to receive(:call)

      described_class.call(params)

      expect(MonthlyBudgets::UpdateAmount).to have_received(:call).with(
        hash_including(
          amount: -params[:amount],
          amount_type: :activity,
        ),
      )
    end
  end
end
