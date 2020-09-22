# frozen_string_literal: true

require 'rails_helper'

describe Api::BudgetsController do
  let(:user) { create(:user) }
  let(:headers) do
    { 'Accept': 'application/json' }
  end

  describe 'POST /api/budgets' do
    context 'when there is no authorization' do
      it 'returns :unauthorized' do
        post '/api/budgets', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end

      it 'creates a new budget board', :aggregate_failures do
        user = create(:user)
        params = {
          name: 'Dummy Budget',
          currency: 'BRL',
          user_id: user.id,
        }

        sign_in(user)

        expect do
          post '/api/budgets', headers: headers, params: params
        end.to change { Budget.count }.by(1)

        expect(Budget.last).to have_attributes(params)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /api/budgets/' do
    context 'when there is no authorization' do
      it 'returns :unauthorized' do
        get '/api/budgets', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    it 'returns all budget boards from current_user', :aggregate_failures do
      create(:budget)
      budget = create(:budget, user: user)

      allow(Api::BudgetSerializer).to receive(:new)

      sign_in(user)

      get '/api/budgets', headers: headers

      expect(response).to have_http_status(:ok)
      expect(Api::BudgetSerializer).to(
        have_received(:new).with([budget]),
      )
    end
  end

  describe 'GET /api/budgets/:id' do
    context 'when there is no authorization' do
      it 'returns :unauthorized' do
        get '/api/budgets', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when budget board doesn't belong to current user",
            :aggregate_failures do
      it 'returns :not_found' do
        budget = create(:budget, user: create(:user))

        allow(Api::BudgetSerializer).to receive(:new)

        sign_in(user)

        get "/api/budgets/#{budget.id}", headers: headers

        expect(response).to have_http_status(:not_found)
        expect(Api::BudgetSerializer).not_to have_received(:new)
      end
    end

    it 'returns the budget board with the specified id', :aggregate_failures do
      budget = create(:budget, user: user)

      allow(Api::BudgetSerializer).to receive(:new)

      sign_in(user)

      get "/api/budgets/#{budget.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(Api::BudgetSerializer).to(
        have_received(:new).with(budget),
      )
    end
  end
end
