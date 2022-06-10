# frozen_string_literal: true

module Api
  class MeController < ApplicationController
    before_action :authenticate_request!

    def show
      render json: MeSerializer.new(current_user)
    end
  end
end
