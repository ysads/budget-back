# frozen_string_literal: true

module Accounts
  class DuplicateError < ApplicationError
    def code
      'accounts/duplicate'
    end

    def message
      'This budget already have an account with that type and name'
    end
  end
end
