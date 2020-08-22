# frozen_string_literal: true

module Api
  class AccountsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_budget!

    def index
      render json: Api::AccountSerializer.new(available_accounts)
    end

    def show
      account = available_accounts.find(params[:id])

      render json: Api::AccountSerializer.new(account)
    end

    private

    def available_accounts
      current_user.budgets.find(params[:budget_id]).accounts
    end

    def account_params
      params.permit(:budget_board_id)
    end
  end
end
