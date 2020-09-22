# frozen_string_literal: true

require 'rails_helper'

describe CategoryGroup do
  describe 'relationships' do
    it { is_expected.to belong_to(:budget) }
    it { is_expected.to have_many(:categories) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
