# frozen_string_literal: true

module Categories
  class CreateWithGroup < ApplicationUseCase
    def initialize(params)
      @params = params
    end

    def call
      ActiveRecord::Base.transaction do
        raise DuplicateError if duplicate_category?

        Category.create!(
          name: params[:name],
          is_recurring: params[:is_recurring],
          category_group: category_group,
        )
      end
    end

    private

    def duplicate_category?
      Category.exists?(
        name: params[:name],
        category_group: category_group,
      )
    end

    def category_group
      @category_group ||= CategoryGroup.find_or_create_by!(
        budget_id: params[:budget_id],
        name: params[:group_name],
      )
    end
  end
end
