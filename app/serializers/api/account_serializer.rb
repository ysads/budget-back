# frozen_string_literal: true

module Api
  class AccountSerializer < ApplicationSerializer
    attributes :balance,
               :cleared_balance,
               :closed_at,
               :name,
               :nature,
               :uncleared_balance

    attribute :type do |obj|
      obj.type.split('::').last.downcase
    end
  end
end
