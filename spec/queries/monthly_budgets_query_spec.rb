# frozen_string_literal: true

require 'rails_helper'

describe MonthlyBudgetsQuery do
  it 'filters by budget id' do
    category_group_one = create(:category_group)
    category_group_two = create(:category_group)

    category_one = create(:category, category_group: category_group_one)
    category_two = create(:category, category_group: category_group_two)

    monthly_budget = create(:monthly_budget, category: category_one)
    create(:monthly_budget, category: category_two)

    response = described_class.execute(budget_id: category_group_one.budget_id)

    expect(response).to contain_exactly(monthly_budget)
  end

  it 'filters by iso month' do
    month_one = create(:month, iso_month: '2021-11')
    month_two = create(:month, iso_month: '2021-12')

    create(:monthly_budget, month: month_one)
    monthly_budget = create(:monthly_budget, month: month_two)

    response = described_class.execute(iso_month: '2021-12')

    expect(response).to contain_exactly(monthly_budget)
  end
end
