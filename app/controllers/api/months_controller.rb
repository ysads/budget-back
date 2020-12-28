# frozen_string_literal: true

module Api
  class MonthsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_budget!

    def show
      month = ::Months::FetchOrCreate.call(permitted_params)

      render json: MonthSerializer.new(month)
    end

    private

    def permitted_params
      params.permit(:budget_id, :iso_month)
    end
  end
end
