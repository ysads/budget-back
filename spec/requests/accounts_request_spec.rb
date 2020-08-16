# frozen_string_literal: true

require 'rails_helper'

describe Api::AccountsController do
  let(:user) { create(:user) }
  let(:headers) do
    { 'Accept': 'application/json' }
  end

  describe 'GET /api/accounts/' do
    context 'when there is no authorization' do
      it 'returns :unauthorized' do
        get '/api/accounts', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    it 'returns accounts from any type', :aggregate_failures do
      tracking_account = create(:tracking_account)
      checking_account = create(:checking_account)

      allow(Api::AccountSerializer).to receive(:new)

      sign_in(user)

      get '/api/accounts', headers: headers

      expect(response).to have_http_status(:ok)
      expect(Api::AccountSerializer).to(
        have_received(:new).with([tracking_account, checking_account])
      )
    end
  end

  describe 'GET /api/accounts/:id' do
    context 'when there is no authorization' do
      it 'returns :unauthorized' do
        account = create(:random_account)

        get "/api/accounts/#{account.id}", headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when given there is not account with given id' do
      it 'returns :not_found' do
        sign_in(create(:user))

        get '/api/accounts/random-uuid', headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end

    it 'returns the account with the specified id', :aggregate_failures do
      account = create(:random_account)

      allow(Api::AccountSerializer).to receive(:new)

      sign_in(user)

      get "/api/accounts/#{account.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(Api::AccountSerializer).to(
        have_received(:new).with(account)
      )
    end
  end
end
