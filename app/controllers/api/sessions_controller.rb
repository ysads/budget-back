# frozen_string_literal: true

module Api
  class SessionsController < Devise::SessionsController
    def create
      resource = warden.authenticate(auth_options)

      if resource
        head :ok
      else
        head :unauthorized
      end
    end

    private

    def respond_to_on_destroy
      head :no_content
    end
  end
end
