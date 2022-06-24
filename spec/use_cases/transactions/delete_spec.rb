# frozen_string_literal: true

require 'rails_helper'

describe Transactions::Delete do
  let(:budget) { create(:budget) }
  let(:category) { create(:category, :with_budget, budget: budget) }
  let(:reference_at) { DateTime.current.iso8601 }
  let(:month) do
    create(:month,
           iso_month: IsoMonth.of(reference_at),
           budget: budget,
           income: 100_00,
           activity: -60_00,
           budgeted: 50_00,
           to_be_budgeted: 50_00)
  end
  let(:amount) { -50_00 }
  let(:monthly_budget) do
    create(:monthly_budget, month: month, category: category)
  end
  let(:account) do
    create(:checking_account, cleared_balance: 10_00)
  end
  let(:transaction) do
    create(:transaction,
           amount: amount,
           reference_at: reference_at,
           monthly_budget: monthly_budget,
           month: month,
           account: account)
  end
  let!(:params) do
    {
      id: transaction.id,
    }
  end

  before { freeze_time }
  after { travel_back }

  it 'removes transaction' do
    expect do
      described_class.call(params)
    end.to change { Transaction.count }.by(-1)

    expect(Transaction.find_by(id: params[:id])).to be_nil
  end

  it 'updates account balance' do
    described_class.call(params)

    expect(account.reload.cleared_balance).to eq(60_00)
  end

  context 'when monthly budget is null' do
    let(:amount) { 50_00 }
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

      monthly_budget = MonthlyBudget.find_by(category_id: params[:category_id])

      expect(monthly_budget).to be_nil
    end
  end

  context 'when monthly budget is present' do
    let(:amount) { -50_00 }
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
