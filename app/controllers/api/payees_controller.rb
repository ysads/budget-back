# frozen_string_literal: true

module Api
  class PayeesController < ApplicationController
    before_action :authenticate_user!

    def index
      render json: PayeeSerializer.new(available_payees)
    end

    private

    def available_payees
      current_user.budgets.find(params[:budget_id]).payees
    end
  end
end
