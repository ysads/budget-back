# frozen_string_literal: true

class TransactionsQuery < ApplicationQuery
  def execute
    filter_account_id
    sort
  end

  def base_relation
    Transaction.all
  end

  private

  def filter_account_id
    return unless params.key?(:account_id)

    @relation = relation.where(account_id: params[:account_id])
  end

  def sort
    @relation = relation.order(created_at: :desc)
  end
end
