# frozen_string_literal: true

require 'rails_helper'

describe Accounts::CreateWithStartingBalance do
  let(:params) do
    {
      account_type: AccountType.all.sample,
      account_name: Faker::Company.name,
      budget_id: create(:budget).id,
      current_balance: rand(100_000),
      payee_name: 'starting balance',
    }
  end

  it 'creates a new account' do
    expect do
      described_class.call(params)
    end.to change { Account::Base.count }.by(1)
  end

  it 'calls service to update account balance' do
    allow(Accounts::UpdateBalance).to receive(:call)

    described_class.call(params)

    transaction = Transaction.last

    expect(Accounts::UpdateBalance).to have_received(:call).with(
      account: Account::Base.last,
      amount: transaction.amount,
      cleared: transaction.cleared?,
    )
  end

  context 'when creating a budget account' do
    it 'calls service to add income to month' do
      allow(Accounts::UpdateBalance).to receive(:call)
      type = %w[cash checking credit].sample

      described_class.call(params.merge(account_type: type))

      transaction = Transaction.last

      expect(Accounts::UpdateBalance).to have_received(:call).with(
        account: Account::Base.last,
        amount: transaction.amount,
        cleared: transaction.cleared?,
      )
    end
  end

  context 'when creating a tracking account' do
    it 'does not call service to add income to month' do
      allow(MonthlyBudgets::UpdateAmount).to receive(:call)
      type = %w[asset savings].sample

      described_class.call(params.merge(account_type: type))

      expect(MonthlyBudgets::UpdateAmount).not_to have_received(:call)
    end
  end

  context 'when creating a debt account' do
    it 'creates a new transaction with negative amount' do
      type = %w[credit].sample

      described_class.call(params.merge(account_type: type))

      expect(Transaction.last.amount).to be_negative
    end

    it 'does not update month income or to_be_budgeted' do
      month = create(:month, iso_month: IsoMonth.of(Date.current))
      prev_income = month.income
      prev_to_be_budgeted = month.to_be_budgeted
      type = %w[credit].sample

      described_class.call(params.merge(account_type: type))

      expect(month.reload).to have_attributes(
        income: prev_income,
        to_be_budgeted: prev_to_be_budgeted,
      )
    end
  end

  context 'when starting balance payee already exists' do
    it 'does not create a new payee' do
      create(:payee, budget_id: params[:budget_id], name: params[:payee_name])

      expect do
        described_class.call(params)
      end.not_to change { Payee.count }
    end
  end
end
