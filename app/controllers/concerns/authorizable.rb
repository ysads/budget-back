# frozen_string_literal: true

require './lib/json_web_token'

module Authorizable
  extend ActiveSupport::Concern

  def authenticate_request!
    response = JsonWebToken.verify(auth_token)
    @current_user = User.find_by(auth_provider_id: response[0]['sub'])
  rescue JWT::VerificationError, JWT::DecodeError
    head :unauthorized
  end

  def current_user
    @current_user
  end

  def auth_token
    request.headers['Authorization']&.split(' ')&.last || ''
  end
end
