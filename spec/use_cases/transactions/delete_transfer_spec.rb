# frozen_string_literal: true

require 'rails_helper'

describe Transactions::DeleteTransfer do
  let(:budget) { create(:budget) }
  let(:category) { create(:category, :with_budget, budget: budget) }
  let(:reference_at) { DateTime.new(2022, 2, 5).iso8601 }
  let(:month) do
    create(:month,
           iso_month: IsoMonth.of(reference_at),
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
           reference_at: reference_at,
           monthly_budget: monthly_budget,
           month: month,
           account: origin_account)
  end
  let(:destination_transaction) do
    create(:transaction,
           amount: 50_00,
           reference_at: reference_at,
           monthly_budget: monthly_budget,
           month: month,
           account: destination_account)
  end
  let(:params) do
    {
      destination_transaction_id: destination_transaction.id,
      origin_transaction_id: origin_transaction.id,
    }
  end

  before do
    freeze_time

    origin_transaction.update(linked_transaction: destination_transaction)
    destination_transaction.update(linked_transaction: origin_transaction)

    allow(MonthlyBudgets::UpdateAmount).to receive(:call).and_call_original
  end

  after { travel_back }

  it 'removes both origin and destination transactions' do
    expect do
      described_class.call(params)
    end.to change { Transaction.count }.by(-2)

    expect(
      Transaction.where(id: [
                          params[:destination_transaction_id],
                          params[:origin_transaction_id],
                        ]),
    ).to be_empty
  end

  it 'updates accounts balance' do
    described_class.call(params)

    expect(origin_account.reload.cleared_balance).to eq(60_00)
    expect(destination_account.reload.cleared_balance).to eq(30_00)
  end

  it 'does not change monthly budgets when accounts nature match' do
    allow(MonthlyBudgets::UpdateAmount).to receive(:call)

    described_class.call(params)

    expect(MonthlyBudgets::UpdateAmount).not_to have_received(:call)
  end

  context 'when transfer is :income' do
    let(:origin_account) do
      create(:asset_account, cleared_balance: 10_00)
    end
    let(:destination_account) do
      create(:checking_account, cleared_balance: 80_00)
    end
    let(:monthly_budget) { nil }

    it "updates month's income and to_be_budgeted" do
      described_class.call(params)

      expect(month.reload).to have_attributes(
        income: 50_00,
        to_be_budgeted: 0,
      )
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

    it "updates month's activity" do
      expect do
        described_class.call(params)
      end.to change { month.reload.activity }.from(-60_00).to(-10_00)
    end

    it "updates monthly budget's activity" do
      expect do
        described_class.call(params)
      end.to change { monthly_budget.reload.activity }.from(-50_00).to(-0)
    end
  end
end
