# frozen_string_literal: true

module Months
  class FetchOrCreate < ApplicationUseCase
    def initialize(params)
      @params = params
    end

    def call
      ::Month.find_or_create_by!(
        budget_id: params[:budget_id],
        iso_month: params[:iso_month],
      )
    end
  end
end
