# frozen_string_literal: true

require 'rails_helper'

describe Api::MonthSerializer do
  it 'serializes using json api' do
    month = create(:month)

    result = described_class.new(month).serializable_hash

    expect(result).to eq(
      data: {
        id: month.id,
        type: :month,
        attributes: {
          activity: month.activity,
          budgeted: month.budgeted,
          budget_id: month.budget_id,
          income: month.income,
          iso_month: month.iso_month,
          to_be_budgeted: month.to_be_budgeted,
        },
      },
    )
  end
end
