# frozen_string_literal: true

require 'rails_helper'

describe Api::MonthlyBudgetsController do
  let(:budget) { create(:budget) }
  let(:headers) do
    {
      Accept: 'application/json',
      Authorization: 'Bearer token',
    }
  end
  let(:params) do
    {
      budgeted: 0,
      category_id: create(:category).id,
      month_id: create(:month).id,
    }
  end

  describe 'GET /api/budgets/:id/monthly_budgets' do
    context 'when there is no authorization' do
      it 'returns :unauthorized' do
        post "/api/budgets/#{budget.id}/monthly_budgets",
             headers: headers,
             params: params

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when given budget id does not belong to current user' do
      it 'returns :unauthorized' do
        other_budget = create(:budget)

        mock_auth!(budget.user)

        post "/api/budgets/#{other_budget.id}/monthly_budgets",
             headers: headers,
             params: params

        expect(response).to have_http_status(:unauthorized)
      end
    end

    it 'creates a new monthly budget' do
      mock_auth!(budget.user)

      expect do
        post "/api/budgets/#{budget.id}/monthly_budgets",
             headers: headers,
             params: params
      end.to change { MonthlyBudget.count }.by(1)
    end

    it 'serializes the newly-created monthly budget' do
      mock_auth!(budget.user)

      allow(Api::MonthlyBudgetSerializer).to receive(:new)

      post "/api/budgets/#{budget.id}/monthly_budgets",
           headers: headers,
           params: params

      expect(Api::MonthlyBudgetSerializer).to(
        have_received(:new).with(MonthlyBudget.last),
      )
    end
  end
end
