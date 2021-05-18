# frozen_string_literal: true

module Api
  class TransactionSerializer < ApplicationSerializer
    attributes :amount,
               :cleared_at,
               :destination_id,
               :memo,
               :monthly_budget_id,
               :origin_id,
               :payee_id,
               :reference_at

    attribute :category_id do |object|
      object.monthly_budget&.category_id
    end

    attribute :payee_name do |object|
      object.payee.name
    end

    belongs_to :monthly_budget
    belongs_to :payee
    belongs_to :origin, serializer: AccountSerializer
  end
end
