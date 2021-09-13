# frozen_string_literal: true

require 'rails_helper'

describe Transactions::Register do
  let(:budget) { create(:budget) }
  let(:payee) { create(:payee, budget: budget) }
  let(:category) { create(:category, :with_budget, budget: budget) }
  let(:account) { create(:checking_account) }
  let(:params) do
    {
      amount: Faker::Number.between(from: 1, to: 1000),
      budget_id: budget.id,
      cleared_at: Time.current.iso8601,
      memo: Faker::Lorem.sentence,
      category_id: category.id,
      account_id: account.id,
      outflow: true,
      payee_name: payee.name,
      reference_at: Time.current.iso8601,
    }
  end

  before { freeze_time }
  after { travel_back }

  it 'creates a new transaction', :aggregate_failures do
    expect do
      described_class.call(params)
    end.to change { Transaction.count }.by(1)

    expect(Transaction.last).to have_attributes(
      cleared_at: DateTime.parse(params[:cleared_at]),
      memo: params[:memo],
      account_id: params[:account_id],
      outflow: params[:outflow],
      payee: payee,
      reference_at: DateTime.parse(params[:reference_at]),
    )
  end

  it 'associate transaction to the categories monthly budget' do
    transaction = described_class.call(params)

    expect(transaction.monthly_budget.category).to eq(category)
  end

  it 'updates account balance' do
    allow(Accounts::UpdateBalance).to receive(:call)

    described_class.call(params)

    transaction = Transaction.last

    expect(Accounts::UpdateBalance).to have_received(:call).with(
      account: account,
      amount: transaction.amount,
      cleared: transaction.cleared?,
    )
  end

  context 'when category is present' do
    it 'updates month activity' do
      month = create(
        :month, budget: budget, iso_month: IsoMonth.of(Time.current)
      )

      expect do
        described_class.call(params.merge(outflow: true))
      end.to change { month.reload.activity }.by(-params[:amount])
    end
  end

  context 'when category is missing' do
    it 'updates month income' do
      month = create(
        :month, budget: budget, iso_month: IsoMonth.of(Time.current)
      )

      expect do
        described_class.call(params.merge(category_id: nil, outflow: false))
      end.to change { month.reload.income }.by(params[:amount])
    end
  end

  context 'when transaction is outflow' do
    it 'creates transaction with negative amount' do
      transaction = described_class.call(params.merge(outflow: true))

      expect(transaction.amount).to eq(-params[:amount])
    end
  end

  context 'when transaction is inflow' do
    it 'creates a transaction with positive amount' do
      transaction = described_class.call(params.merge(outflow: false))

      expect(transaction.amount).to eq(params[:amount])
    end
  end

  context 'when payee does not exist yet' do
    let(:payee) { build(:payee, name: 'a-payee') }

    it 'creates a new payee' do
      expect do
        described_class.call(params.merge(payee_name: 'other-payee'))
      end.to change { Payee.count }.by(1)

      expect(Transaction.last.payee.name).to eq('other-payee')
    end
  end
end
