# frozen_string_literal: true

module Account
  class Base < ApplicationRecord
    self.table_name = 'accounts'

    belongs_to :budget

    validates :name, :cleared_balance, :uncleared_balance, presence: true

    def balance
      cleared_balance + uncleared_balance
    end
  end
end
