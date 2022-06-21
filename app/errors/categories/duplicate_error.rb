# frozen_string_literal: true

module Categories
  class DuplicateError < ApplicationError
    def code
      'categories/duplicate'
    end

    def message
      "Duplicate category. You can't register the same category twice."
    end
  end
end
