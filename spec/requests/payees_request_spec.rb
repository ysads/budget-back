# frozen_string_literal: true

require 'rails_helper'

describe Api::PayeesController do
  let(:budget) { create(:budget) }
  let(:headers) do
    { Accept: 'application/json' }
  end

  describe 'GET /api/budgets/:id/payees/' do
    context 'when there is no authorization' do
      it 'returns :unauthorized' do
        get "/api/budgets/#{budget.id}/payees", headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when given budget id does not belong to current user' do
      it 'returns :unauthorized' do
        other_budget = create(:budget)

        sign_in(budget.user)

        get "/api/budgets/#{other_budget.id}/payees", headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    it 'returns payees from that budget', :aggregate_failures do
      payee = create(:payee, budget: budget)
      other_budget = create(:budget)
      create(:payee, budget: other_budget)

      allow(Api::PayeeSerializer).to receive(:new)

      sign_in(budget.user)

      get "/api/budgets/#{budget.id}/payees", headers: headers

      expect(response).to have_http_status(:ok)
      expect(Api::PayeeSerializer).to have_received(:new).with([payee])
    end
  end
end
