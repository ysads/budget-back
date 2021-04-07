# frozen_string_literal: true

class MonthlyBudgetsQuery < ApplicationQuery
  def execute
    filter_budget_id
    filter_iso_month
  end

  def base_relation
    MonthlyBudget
  end

  private

  def filter_budget_id
    return unless params.key?(:budget_id)

    @relation = relation.joins(category: :category_group).where(
      category_groups: { budget_id: params[:budget_id] },
    )
  end

  def filter_iso_month
    return unless params.key?(:iso_month)

    @relation = relation.joins(:month).where(
      month: { iso_month: params[:iso_month] },
    )
  end
end
