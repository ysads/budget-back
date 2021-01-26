# frozen_string_literal: true

require 'rails_helper'

describe Api::CategoryGroupSerializer do
  it 'serializes using json api' do
    category_group = create(:category_group)

    result = described_class.new(category_group).serializable_hash

    expect(result).to eq(
      data: {
        id: category_group.id,
        type: :category_group,
        attributes: {
          name: category_group.name,
          budget_id: category_group.budget_id,
        },
      },
    )
  end
end
