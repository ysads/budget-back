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

    belongs_to :monthly_budget
    belongs_to :payee
    belongs_to :origin, serializer: AccountSerializer
  end
end
