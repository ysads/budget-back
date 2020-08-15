# frozen_string_literal: true

require 'rails_helper'

describe Api::MeSerializer do
  it 'serializes using json api' do
    user = create(:user)

    result = described_class.new(user).serializable_hash

    expect(result).to eq(
      data: {
        id: user.id,
        type: :me,
        attributes: {
          email: user.email,
          name: user.name
        }
      }
    )
  end
end
