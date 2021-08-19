# frozen_string_literal: true

class TransactionsQuery < ApplicationQuery
  def execute
    filter_origin_id
    sort
  end

  def base_relation
    Transaction.all
  end

  private

  def filter_origin_id
    return unless params.key?(:origin_id)

    @relation = relation.where(origin_id: params[:origin_id])
  end

  def sort
    @relation = relation.order(created_at: :desc)
  end
end
