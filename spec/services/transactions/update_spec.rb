# frozen_string_literal: true

require 'rails_helper'

describe Transactions::Update do
  let!(:transaction) { create(:transaction) }
  let(:budget) { create(:budget) }
  let(:payee) { create(:payee, budget: budget) }
  let(:category) { create(:category, :with_budget, budget: budget) }
  let(:origin_account) { create(:checking_account) }
  let(:params) do
    {
      amount: Faker::Number.between(from: 1, to: 1000),
      budget_id: budget.id,
      cleared_at: Time.current.iso8601,
      memo: Faker::Lorem.sentence,
      category_id: category.id,
      origin_id: origin_account.id,
      outflow: true,
      payee_name: payee.name,
      reference_at: Time.current.iso8601,
    }
  end

  before { freeze_time }
  after { travel_back }

  it 'updates transaction params' do
    result = described_class.call(transaction: transaction,
                                  updated_params: params)

    expect(result).to have_attributes(
      amount: -params[:amount],
      cleared_at: DateTime.parse(params[:cleared_at]),
      memo: params[:memo],
      origin_id: params[:origin_id],
      outflow: params[:outflow],
      reference_at: DateTime.parse(params[:reference_at]),
    )
  end

  it 'does not create a new transaction' do
    expect do
      described_class.call(transaction: transaction, updated_params: params)
    end.not_to change { Transaction.count }
  end

  it 'associates with proper month and monthly budget' do
    month = create(:month,
                   budget_id: budget.id,
                   iso_month: IsoMonth.of(params[:reference_at]))
    monthly_budget = create(:monthly_budget, category: category, month: month)

    result = described_class.call(transaction: transaction,
                                  updated_params: params)

    expect(result).to have_attributes(
      month: month,
      monthly_budget: monthly_budget,
    )
  end

  context 'when there is no month matching reference_at' do
    it 'creates a new month' do
      params[:reference_at] = '2010-01-01 05:00:00'

      expect do
        described_class.call(transaction: transaction, updated_params: params)
      end.to change { Month.count }.by(1)
    end
  end

  context 'when there is no monthly_budget matching updated attributes' do
    it 'creates a new monthly budget' do
      params[:reference_at] = '2010-01-01 05:00:00'

      expect do
        described_class.call(transaction: transaction, updated_params: params)
      end.to change { MonthlyBudget.count }.by(1)
    end
  end
end
