# frozen_string_literal: true

require 'rails_helper'

describe Api::CategorySerializer do
  it 'serializes using json api' do
    category = create(:category)

    result = described_class.new(category).serializable_hash

    expect(result).to eq(
      data: {
        id: category.id,
        type: :category,
        attributes: {
          name: category.name,
          category_group_id: category.category_group_id,
        },
      },
    )
  end
end
