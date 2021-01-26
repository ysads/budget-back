# frozen_string_literal: true

module Api
  class CategorySerializer < ApplicationSerializer
    attributes :name, :category_group_id
  end
end
