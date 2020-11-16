# frozen_string_literal: true

module Api
  class CategoryGroupsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_budget!

    def index
      render json: Api::CategoryGroupSerializer.new(available_groups)
    end

    private

    def available_groups
      Budget.find(params[:budget_id]).category_groups
    end
  end
end
