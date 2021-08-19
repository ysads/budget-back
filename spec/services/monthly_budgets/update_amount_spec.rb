# frozen_string_literal: true

require 'rails_helper'

describe MonthlyBudgets::UpdateAmount do
  let(:monthly_budget) { create(:monthly_budget) }
  let(:month) { monthly_budget.month }
  let(:amount) { rand(-20_000..20_000) }

  describe 'when amount_type is :income' do
    it "updates month's income" do
      expect do
        described_class.call(amount: amount,
                             amount_type: :income,
                             month: month,
                             monthly_budget: nil)
      end.to change { month.reload.income }.by(amount)
    end

    it "updates months's to_be_budgeted" do
      expect do
        described_class.call(amount: amount,
                             amount_type: :income,
                             month: month,
                             monthly_budget: nil)
      end.to change { month.reload.to_be_budgeted }.by(amount)
    end

    it 'does not update monthly budget' do
      expect do
        described_class.call(amount: amount,
                             amount_type: :income,
                             month: month,
                             monthly_budget: nil)
      end.not_to change { monthly_budget.reload.attributes }
    end
  end

  describe 'when amount_type is :activity' do
    it "updates monthly_budget's activity" do
      expect do
        described_class.call(amount: amount,
                             amount_type: :activity,
                             month: month,
                             monthly_budget: monthly_budget)
      end.to change { monthly_budget.reload.activity }.by(amount)
    end

    it "updates months's activity" do
      expect do
        described_class.call(amount: amount,
                             amount_type: :activity,
                             month: month,
                             monthly_budget: monthly_budget)
      end.to change { month.reload.activity }.by(amount)
    end

    it "does not update months's to_be_budgeted" do
      expect do
        described_class.call(amount: amount,
                             amount_type: :activity,
                             month: month,
                             monthly_budget: monthly_budget)
      end.not_to change { month.reload.to_be_budgeted }
    end
  end
end
