# frozen_string_literal: true

require 'rails_helper'

describe Api::MeController do
  let(:headers) do
    {
      Accept: 'application/json',
      Authorization: 'Bearer token',
    }
  end

  describe 'GET /api/me' do
    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        get '/api/me', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    it 'returns ok', :aggregate_failures do
      user = create(:user)
      mock_auth!(user)

      get '/api/me', headers: headers

      expect(response).to have_http_status(:ok)
    end
  end
end
