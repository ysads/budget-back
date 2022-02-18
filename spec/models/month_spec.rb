# frozen_string_literal: true

require 'rails_helper'

describe Month do
  describe 'relationships' do
    it { is_expected.to belong_to(:budget) }
    it { is_expected.to have_many(:monthly_budgets) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:iso_month) }
    it { is_expected.to validate_presence_of(:income) }
    it { is_expected.to validate_presence_of(:budgeted) }
    it { is_expected.to validate_presence_of(:activity) }
    it { is_expected.to validate_presence_of(:to_be_budgeted) }

    it 'validates activity is at most zero' do
      expect(build(:month, activity: 10_00)).not_to be_valid
      expect(build(:month, activity: 0)).to be_valid
      expect(build(:month, activity: -10_00)).to be_valid
    end

    it 'validates income is at least zero' do
      expect(build(:month, income: 10_00)).to be_valid
      expect(build(:month, income: 0)).to be_valid
      expect(build(:month, income: -10_00)).not_to be_valid
    end

    it 'validates budgeted is at least zero' do
      expect(build(:month, budgeted: 10_00)).to be_valid
      expect(build(:month, budgeted: 0)).to be_valid
      expect(build(:month, budgeted: -10_00)).not_to be_valid
    end
  end
end
