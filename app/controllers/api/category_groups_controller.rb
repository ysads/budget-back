# frozen_string_literal: true

module Api
  class CategoryGroupsController < ApplicationController
    before_action :authenticate_request!
    before_action :authorize_budget!

    # POST /api/budgets/:budget_id/category_groups
    def create
      category = CategoryGroup.create!(create_params)

      render json: Api::CategoryGroupSerializer.new(category)
    end

    # GET /api/budgets/:budget_id/category_groups
    def index
      render json: Api::CategoryGroupSerializer.new(available_groups)
    end

    private

    def create_params
      params.permit(:budget_id, :name)
    end

    def available_groups
      Budget.find(params[:budget_id]).category_groups
    end
  end
end
