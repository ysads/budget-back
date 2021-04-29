# frozen_string_literal: true

module Accounts
  class CreateWithStartingBalance < ApplicationUseCase
    def initialize(params)
      @params = params
    end

    def call
      ActiveRecord::Base.transaction do
        create_account
        create_initial_transaction
        update_account_balance
        add_income_to_month
        account
      end
    end

    private

    attr_accessor :account, :params, :transaction

    def initial_balance
      return params[:current_balance] unless account.debt?

      params[:current_balance] * -1
    end

    def starting_balance_payee
      Payee.find_or_create_by!(
        budget_id: params[:budget_id],
        name: params[:payee_name],
      )
    end

    def create_account
      @account = Accounts::Create.call(
        budget_id: params[:budget_id],
        name: params[:account_name],
        type: params[:account_type],
      )
    end

    def create_initial_transaction
      @transaction = Transaction.create!(
        amount: initial_balance,
        cleared_at: DateTime.current,
        origin: account,
        outflow: account.debt?,
        payee: starting_balance_payee,
        reference_at: DateTime.current,
      )
    end

    def update_account_balance
      Accounts::UpdateBalance.call(
        account: account,
        transaction: transaction,
      )
    end

    def add_income_to_month
      return if !account.budget? || account.debt?

      Months::AddIncome.call(
        amount: initial_balance,
        budget_id: params[:budget_id],
        iso_month: IsoMonth.of(Date.current)
      )
    end
  end
end
