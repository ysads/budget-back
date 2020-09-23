# frozen_string_literal: true

module Accounts
  class InvalidTypeError < ApplicationError
    def code
      'accounts/invalid-type'
    end

    def message
      'This account type is not valid'
    end
  end
end
