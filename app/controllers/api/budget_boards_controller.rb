# frozen_string_literal: true

module Api
  class BudgetBoardsController < ApplicationController
    before_action :authenticate_user!

    def create
      BudgetBoard.create!(permitted_params)

      head :ok
    end

    def index
      render json: Api::BudgetBoardSerializer.new(available_budgets)
    end

    private

    def available_budgets
      current_user.budget_boards
    end

    def permitted_params
      params.permit(:name, :currency, :user_id)
    end
  end
end
