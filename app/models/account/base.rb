# frozen_string_literal: true

module Account
  class Base < ApplicationRecord
    self.table_name = 'accounts'

    belongs_to :budget

    validates :name, :cleared_balance, :uncleared_balance, presence: true

    def budget?
      nature.eql?(:budget)
    end

    def tracking?
      !budget?
    end

    def balance
      cleared_balance + uncleared_balance
    end
  end
end
