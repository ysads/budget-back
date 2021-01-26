# frozen_string_literal: true

require 'rails_helper'

describe Budget do
  describe 'relationships' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:category_groups) }
    it { is_expected.to have_many(:accounts).class_name('Account::Base') }
    it { is_expected.to have_many(:months) }
    it { is_expected.to have_many(:payees) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:currency) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:date_format) }
  end
end
