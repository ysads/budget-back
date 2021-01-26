# frozen_string_literal: true

module Api
  class CategoriesController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_budget!

    # POST /api/budgets/:budget_id/categories
    def create
      category = Category.create!(create_params)

      render json: Api::CategorySerializer.new(category)
    end

    # GET /api/budgets/:budget_id/categories
    def index
      render json: Api::CategorySerializer.new(available_categories)
    end

    private

    def create_params
      params.permit(:category_group_id, :name)
    end

    def available_categories
      Category
        .joins(:category_group)
        .where(category_groups: { budget_id: params[:budget_id] })
    end
  end
end
