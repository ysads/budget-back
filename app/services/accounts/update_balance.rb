# frozen_string_literal: true

module Accounts
  class UpdateBalance < ApplicationService
    def initialize(account:, transaction:)
      @account = account
      @transaction = transaction
    end

    def call
      update_balance
    end

    private

    attr_accessor :account, :transaction

    def update_balance
      if transaction.cleared?
        account.update(
          cleared_balance: account.cleared_balance + transaction.amount,
        )
      else
        account.update(
          uncleared_balance: account.uncleared_balance + transaction.amount,
        )
      end
    end
  end
end
