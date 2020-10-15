# frozen_string_literal: true

require 'rails_helper'

describe Account::Credit do
  describe '#debt?' do
    it { expect(subject.debt?).to eq(true) }
  end

  describe '#budget?' do
    it { expect(subject.budget?).to eq(true) }
  end
end
