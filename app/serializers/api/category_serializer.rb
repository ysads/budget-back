# frozen_string_literal: true

module Api
  class CategorySerializer < ApplicationSerializer
    attributes :name

    attribute :group_name do |obj|
      obj.category_group.name
    end
  end
end
