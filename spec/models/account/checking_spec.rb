# frozen_string_literal: true

require 'rails_helper'

describe Account::Checking do
  describe '#debt?' do
    it { expect(subject.debt?).to eq(false) }
  end

  describe '#budget?' do
    it { expect(subject.budget?).to eq(true) }
  end
end
