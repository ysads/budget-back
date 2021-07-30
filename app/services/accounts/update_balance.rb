# frozen_string_literal: true

module Accounts
  class UpdateBalance < ApplicationService
    def initialize(account:, amount:, cleared:)
      @account = account
      @amount = amount
      @cleared = cleared
    end

    def call
      update_balance
    end

    private

    attr_accessor :account, :amount, :cleared

    def update_balance
      if cleared
        account.update(
          cleared_balance: account.cleared_balance + amount,
        )
      else
        account.update(
          uncleared_balance: account.uncleared_balance + amount,
        )
      end
    end
  end
end
