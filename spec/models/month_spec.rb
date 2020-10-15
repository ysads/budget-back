# frozen_string_literal: true

require 'rails_helper'

describe Month do
  describe 'relationships' do
    it { is_expected.to have_many(:monthly_budgets) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:iso_month) }
    it { is_expected.to validate_presence_of(:income) }
    it { is_expected.to validate_presence_of(:budgeted) }
    it { is_expected.to validate_presence_of(:activity) }
    it { is_expected.to validate_presence_of(:to_be_budgeted) }
  end
end
