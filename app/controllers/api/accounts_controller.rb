# frozen_string_literal: true

module Api
  class AccountsController < ApplicationController
    before_action :authenticate_user!

    def index
      accounts = Account::Base.where(account_params)

      render json: Api::AccountSerializer.new(accounts)
    end

    def show
      account = Account::Base.find(params[:id])

      render json: Api::AccountSerializer.new(account)
    end

    private

    def account_params
      params.permit(:budget_board_id)
    end
  end
end
