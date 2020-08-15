# frozen_string_literal: true

require 'rails_helper'

describe Api::SessionsController do
  let(:headers) do
    { 'Accept': 'application/json' }
  end

  describe 'POST /api/sign_in' do
    context 'when valid credentials are passed' do
      it 'sets a session via cookie', :aggregate_failures do
        user = create(:user)
        payload = {
          user: {
            email: user.email,
            password: user.password
          }
        }

        post '/api/sign_in', params: payload

        expect(response).to have_http_status(:ok)
        expect(response.headers['Set-Cookie']).to be_present
      end
    end

    context 'when invalid credentials are given' do
      it 'returns unauthorized' do
        user = create(:user)
        payload = {
          user: {
            email: user.email,
            password: 'wrong_password'
          }
        }

        post '/api/sign_in', headers: headers, params: payload

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/sign_out' do
    it 'returns no_content' do
      delete '/api/sign_out'

      expect(response).to have_http_status(:no_content)
    end
  end
end
