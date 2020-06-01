# frozen_string_literal: true

module Account
  class Base < ApplicationRecord
    self.table_name = 'accounts'

    validates :name, :cleared_balance, :uncleared_balance, presence: true
  end
end
