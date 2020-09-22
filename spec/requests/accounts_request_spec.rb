# frozen_string_literal: true

require 'rails_helper'

describe Api::AccountsController do
  let(:budget) { create(:budget) }
  let(:headers) do
    { 'Accept': 'application/json' }
  end

  describe 'GET /api/budgets/:id/accounts/' do
    context 'when there is no authorization' do
      it 'returns :unauthorized' do
        get '/api/budgets/:id/accounts', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when given budget id does not belong to current user' do
      it 'returns :unauthorized' do
        other_budget = create(:budget)

        sign_in(budget.user)

        get "/api/budgets/#{other_budget.id}/accounts", headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    it 'returns accounts from any type at given budget', :aggregate_failures do
      create(:checking_account, budget: create(:budget))
      asset_account = create(:asset_account, budget: budget)
      checking_account = create(:checking_account, budget: budget)

      allow(Api::AccountSerializer).to receive(:new)

      sign_in(budget.user)

      get "/api/budgets/#{budget.id}/accounts", headers: headers

      expect(response).to have_http_status(:ok)
      expect(Api::AccountSerializer).to have_received(:new).with(
        [asset_account, checking_account]
      )
    end
  end

  describe 'GET /api/budgets/:id/accounts/:id' do
    context 'when there is no authorization' do
      it 'returns :unauthorized' do
        account = create(:random_account)

        get "/api/budgets/#{account.budget_id}/accounts/#{account.id}",
            headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when given budget id does not belong to current user' do
      it 'returns :unauthorized' do
        other_budget = create(:budget)
        account = create(:random_account, budget: other_budget)

        sign_in(budget.user)

        get "/api/budgets/#{other_budget.id}/accounts/#{account.id}",
            headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when there is no account in given budget with given id' do
      it 'returns :not_found' do
        sign_in(budget.user)

        get "/api/budgets/#{budget.id}/accounts/random-uuid", headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end

    it 'returns the account with the specified id', :aggregate_failures do
      account = create(:random_account, budget: budget)

      allow(Api::AccountSerializer).to receive(:new)

      sign_in(budget.user)

      get "/api/budgets/#{budget.id}/accounts/#{account.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(Api::AccountSerializer).to(
        have_received(:new).with(account)
      )
    end
  end
end
