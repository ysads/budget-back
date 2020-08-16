# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  respond_to :json

  private

  def not_found
    head :not_found
  end
end
