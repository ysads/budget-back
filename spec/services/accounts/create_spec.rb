# frozen_string_literal: true

require 'rails_helper'

describe Accounts::Create do
  let(:budget) { create(:budget) }
  let(:name) { Faker::Company.name }
  let(:type) { AccountType.all.sample }

  it 'creates an account with no balance', :aggregate_failures do
    expect do
      described_class.call(budget_id: budget.id, name: name, type: type)
    end.to change { Account::Base.count }.by(1)

    expect(Account::Base.last).to have_attributes(
      budget_id: budget.id,
      name: name,
      type: "Account::#{type.camelize}",
    )
  end

  context 'when type is not listed' do
    let(:type) { 'bad-type' }

    it 'raises InvalidTypeError' do
      expect do
        described_class.call(budget_id: budget.id, name: name, type: type)
      end.to raise_error { Accounts::InvalidTypeError.new }
    end
  end
end
