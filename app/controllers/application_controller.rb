# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Authorizable
  include ActionController::MimeResponds

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ApplicationError, with: :render_error

  respond_to :json

  protected

  def authorize_budget!
    return if available_budgets.exists?(id: params[:budget_id])

    head :unauthorized
  end

  private

  def available_budgets
    current_user.budgets
  end

  def render_error(error)
    render json: error.to_h, status: :bad_request
  end

  def not_found
    head :not_found
  end
end
