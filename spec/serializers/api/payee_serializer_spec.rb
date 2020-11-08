# frozen_string_literal: true

require 'rails_helper'

describe Api::PayeeSerializer do
  it 'serializes using json api' do
    payee = create(:payee)

    result = described_class.new(payee).serializable_hash

    expect(result).to eq(
      data: {
        id: payee.id,
        type: :payee,
        attributes: {
          name: payee.name,
        },
      },
    )
  end
end
