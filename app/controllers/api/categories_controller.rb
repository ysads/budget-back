# frozen_string_literal: true

module Api
  class CategoriesController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_budget!

    def index
      render json: Api::CategorySerializer.new(available_categories)
    end

    def available_categories
      Category
        .joins(:category_group)
        .where(category_groups: { budget_id: params[:budget_id] })
    end
  end
end
