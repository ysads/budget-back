# frozen_string_literal: true

require 'rails_helper'

describe Account::Savings do
  describe '#debt?' do
    it { expect(subject.debt?).to eq(false) }
  end

  describe '#budget?' do
    it { expect(subject.budget?).to eq(false) }
  end
end
