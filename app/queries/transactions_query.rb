# frozen_string_literal: true

class TransactionsQuery < ApplicationQuery
  def execute
    filter_origin_id
  end

  def base_relation
    Transaction
  end

  private

  def filter_origin_id
    return unless params.key?(:origin_id)

    @relation = relation.where(origin_id: params[:origin_id])
  end
end
