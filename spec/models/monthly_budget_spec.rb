# frozen_string_literal: true

require 'rails_helper'

describe MonthlyBudget do
  describe 'relationships' do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to belong_to(:month) }
    it { is_expected.to have_many(:transactions) }
  end
end
