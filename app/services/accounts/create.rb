# frozen_string_literal: true

module Accounts
  class Create < ApplicationService
    def initialize(budget_id:, name:, type:)
      @budget_id = budget_id
      @name = name
      @type = type
    end

    def call
      raise InvalidTypeError unless account_class.present?
      raise DuplicateError if duplicate_account?

      create_account
    end

    private

    attr_accessor :name, :budget_id, :type

    def duplicate_account?
      Account::Base.exists?(name: @name)
    end

    def account_class
      AccountType.class_of(@type)
    end

    def create_account
      account_class.create!(
        budget_id: budget_id,
        name: @name,
        cleared_balance: 0,
        uncleared_balance: 0,
      )
    end
  end
end
