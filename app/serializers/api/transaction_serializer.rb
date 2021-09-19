# frozen_string_literal: true

module Api
  class TransactionSerializer < ApplicationSerializer
    attributes :account_id,
               :amount,
               :cleared_at,
               :linked_transaction_id,
               :memo,
               :monthly_budget_id,
               :outflow,
               :payee_id,
               :reference_at,
               :unsigned_amount

    attribute :category_id do |object|
      object.monthly_budget&.category_id
    end

    attribute :payee_name do |object|
      object.payee&.name
    end

    attribute :linked_transaction_account_id do |object|
      object.linked_transaction&.account_id
    end

    belongs_to :monthly_budget
    belongs_to :payee
    belongs_to :account, serializer: AccountSerializer
  end
end
