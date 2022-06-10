# frozen_string_literal: true

module Api
  class AccountsController < ApplicationController
    before_action :authenticate_request!
    before_action :authorize_budget!

    def index
      render json: Api::AccountSerializer.new(available_accounts)
    end

    def show
      account = available_accounts.find(params[:id])

      render json: Api::AccountSerializer.new(account)
    end

    def create
      account = Accounts::CreateWithStartingBalance.call(create_params)

      render json: Api::AccountSerializer.new(account)
    end

    private

    def available_accounts
      current_user.budgets.find(params[:budget_id]).accounts
    end

    def create_params
      params.permit(
        :account_name, :account_type, :budget_id, :current_balance, :payee_name
      )
    end
  end
end
