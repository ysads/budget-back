# frozen_string_literal: true

module Api
  class MeSerializer < ApplicationSerializer
    attributes :name, :email

    attribute :default_budget_id do |object|
      object.budgets.first&.id
    end
  end
end
