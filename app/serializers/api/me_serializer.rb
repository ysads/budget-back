# frozen_string_literal: true

module Api
  class MeSerializer < ApplicationSerializer
    attributes :name, :email
  end
end
