# frozen_string_literal: true

require 'rails_helper'

describe Transactions::UpdateTransfer do
  let(:budget) { create(:budget) }
  let(:category) { create(:category, :with_budget, budget: budget) }
  let(:transfer_type) { :rebalance }
  let(:old_reference) { DateTime.new(2022, 2, 5).iso8601 }
  let(:new_reference) { DateTime.new(2022, 2, 10).iso8601 }
  let(:month) do
    create(:month,
           iso_month: IsoMonth.of(new_reference),
           budget: budget,
           income: 100_00,
           activity: -60_00,
           budgeted: 50_00,
           to_be_budgeted: 50_00)
  end
  let(:monthly_budget) do
    create(:monthly_budget, month: month, category: category)
  end
  let(:origin_account) do
    create(:checking_account, cleared_balance: 10_00)
  end
  let(:destination_account) do
    create(:checking_account, cleared_balance: 80_00)
  end
  let(:origin_transaction) do
    create(:transaction,
           amount: -50_00,
           reference_at: old_reference,
           monthly_budget: monthly_budget,
           month: month,
           account: origin_account)
  end
  let(:destination_transaction) do
    create(:transaction,
           amount: 50_00,
           reference_at: old_reference,
           monthly_budget: monthly_budget,
           month: month,
           account: destination_account)
  end
  let(:params) do
    {
      amount: 20_00,
      budget_id: budget.id,
      category_id: category.id,
      cleared_at: Time.current.iso8601,
      destination_id: destination_account.id,
      destination_transaction_id: destination_transaction.id,
      memo: Faker::Lorem.sentence,
      origin_id: origin_account.id,
      origin_transaction_id: origin_transaction.id,
      outflow: true,
      type: transfer_type,
      reference_at: new_reference,
    }
  end

  before do
    freeze_time

    origin_transaction.update(linked_transaction: destination_transaction)
    destination_transaction.update(linked_transaction: origin_transaction)

    allow(MonthlyBudgets::UpdateAmount).to receive(:call).and_call_original
  end

  after { travel_back }

  it 'updates outbound transaction' do
    described_class.call(params)

    expect(origin_transaction.reload).to have_attributes(
      amount: -20_00,
      outflow: true,
      reference_at: DateTime.parse(new_reference),
    )
  end

  it 'updates inbound transaction' do
    described_class.call(params)

    expect(destination_transaction.reload).to have_attributes(
      amount: 20_00,
      outflow: false,
      reference_at: DateTime.parse(new_reference),
    )
  end

  it 'updates accounts balance' do
    described_class.call(params)

    expect(origin_account.reload.cleared_balance).to eq(40_00)
    expect(destination_account.reload.cleared_balance).to eq(50_00)
  end

  it 'does not change monthly budgets for :rebalance transfers' do
    allow(MonthlyBudgets::UpdateAmount).to receive(:call)

    described_class.call(params)

    expect(MonthlyBudgets::UpdateAmount).not_to have_received(:call)
  end

  context 'when reference changes to a new month' do
    let(:new_reference) { DateTime.new(2022, 3, 10).iso8601 }
    let(:month) { create(:month, iso_month: '2022-02') }

    it 'creates a new month if that' do
      expect do
        described_class.call(params)
      end.to change { Month.where(iso_month: '2022-03').count }.by(1)
    end
  end

  context 'when transfer is :income' do
    let(:origin_account) do
      create(:asset_account, cleared_balance: 10_00)
    end
    let(:destination_account) do
      create(:checking_account, cleared_balance: 80_00)
    end
    let(:monthly_budget) { nil }
    let(:transfer_type) { :income }

    it "updates month's attributes" do
      described_class.call(params)

      expect(month.reload).to have_attributes(
        income: 70_00,
        to_be_budgeted: 20_00,
      )
    end

    it "updates accounts' balance" do
      described_class.call(params)

      expect(origin_account.reload.cleared_balance).to eq(40_00)
      expect(destination_account.reload.cleared_balance).to eq(50_00)
    end

    it 'does not update monthly budget' do
      described_class.call(params)

      category = MonthlyBudget.find_by(category_id: params[:category_id])

      expect(category).to be_nil
    end
  end

  context 'when transfer is a :spending' do
    let(:origin_account) do
      create(:checking_account, cleared_balance: 10_00)
    end
    let(:destination_account) do
      create(:asset_account, cleared_balance: 80_00)
    end
    let(:monthly_budget) do
      create(:monthly_budget,
             month: month,
             category: category,
             activity: -50_00,
             budgeted: 50_00)
    end
    let(:transfer_type) { :spending }

    it "updates month's activity" do
      expect do
        described_class.call(params)
      end.to change { month.reload.activity }.from(-60_00).to(-30_00)
    end

    it "updates monthly budget's activity" do
      expect do
        described_class.call(params)
      end.to change { monthly_budget.reload.activity }.from(-50_00).to(-20_00)
    end
  end
end
