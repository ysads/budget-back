# frozen_string_literal: true

require 'rails_helper'

describe MonthlyBudget do
  describe 'relationships' do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to belong_to(:month) }
    it { is_expected.to have_many(:transactions) }
  end

  describe 'validations' do
    it 'validates activity is at most zero' do
      expect(build(:monthly_budget, activity: 10_00)).not_to be_valid
      expect(build(:monthly_budget, activity: 0)).to be_valid
      expect(build(:monthly_budget, activity: -10_00)).to be_valid
    end

    it 'validates budgeted is at least zero' do
      expect(build(:monthly_budget, budgeted: 10_00)).to be_valid
      expect(build(:monthly_budget, budgeted: 0)).to be_valid
      expect(build(:monthly_budget, budgeted: -10_00)).not_to be_valid
    end
  end

  describe '#available' do
    it 'is the sum between budgeted and activity', :aggregate_failures do
      expect(
        build(:monthly_budget, budgeted: 3_000, activity: -2_000).available,
      ).to eq(1_000)
      expect(
        build(:monthly_budget, budgeted: 2_000, activity: 3_000).available,
      ).to eq(5_000)
    end
  end
end
