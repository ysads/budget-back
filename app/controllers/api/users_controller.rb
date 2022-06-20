# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    def create
      User.create!(permitted_params)

      head :ok
    end

    private

    def permitted_params
      params.permit(:name, :email, :auth_provider_id)
    end
  end
end
