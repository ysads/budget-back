# frozen_string_literal: true

require 'rails_helper'

describe Api::CategoryGroupsController do
  let(:budget) { create(:budget) }
  let(:headers) do
    { 'Accept': 'application/json' }
  end

  describe 'GET /api/budgets/:id/category_groups' do
    context 'when there is no authorization' do
      it 'returns :unauthorized' do
        account = create(:random_account)

        get "/api/budgets/#{account.budget_id}/category_groups",
            headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when given budget id does not belong to current user' do
      it 'returns :unauthorized' do
        other_budget = create(:budget)

        sign_in(budget.user)

        get "/api/budgets/#{other_budget.id}/category_groups",
            headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    it 'returns category groups within given budget', :aggregate_failures do
      category_group = create(:category_group, budget: budget)

      allow(Api::CategoryGroupSerializer).to receive(:new)

      sign_in(budget.user)

      get "/api/budgets/#{budget.id}/category_groups", headers: headers

      expect(response).to have_http_status(:ok)
      expect(Api::CategoryGroupSerializer).to(
        have_received(:new).with([category_group]),
      )
    end
  end
end
