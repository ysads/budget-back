# frozen_string_literal: true

module Api
  class CategoryGroupSerializer < ApplicationSerializer
    attributes :name, :budget_id
  end
end
