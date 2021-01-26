# frozen_string_literal: true

require 'rails_helper'

describe Api::CategoryGroupsController do
  let(:budget) { create(:budget) }
  let(:headers) do
    { 'Accept': 'application/json' }
  end

  describe 'POST /api/budgets/:id/categories' do
    let(:params) do
      {
        budget_id: budget.id,
        category_group_id: create(:category_group).id,
        name: Faker::Commerce.department,
      }
    end

    context 'when there is no authorization' do
      it 'returns :unauthorized' do
        post "/api/budgets/#{budget.id}/categories",
             headers: headers,
             params: params

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when given budget id does not belong to current user' do
      it 'returns :unauthorized' do
        other_budget = create(:budget)

        sign_in(budget.user)

        post "/api/budgets/#{other_budget.id}/categories",
             headers: headers,
             params: params

        expect(response).to have_http_status(:unauthorized)
      end
    end

    it 'creates a new category within given budget', :aggregate_failures do
      sign_in(budget.user)

      expect do
        post "/api/budgets/#{budget.id}/categories",
             headers: headers,
             params: params
      end.to change { Category.count }.by(1)

      expect(Category.last).to have_attributes(
        category_group_id: params[:category_group_id],
        name: params[:name],
      )
    end

    it 'serializes back the newly created category', :aggregate_failures do
      allow(Api::CategorySerializer).to receive(:new)

      sign_in(budget.user)

      post "/api/budgets/#{budget.id}/categories",
           headers: headers,
           params: params

      expect(response).to have_http_status(:ok)
      expect(Api::CategorySerializer).to(
        have_received(:new).with(Category.last),
      )
    end
  end

  describe 'GET /api/budgets/:id/categories' do
    context 'when there is no authorization' do
      it 'returns :unauthorized' do
        account = create(:random_account)

        get "/api/budgets/#{account.budget_id}/categories",
            headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when given budget id does not belong to current user' do
      it 'returns :unauthorized' do
        other_budget = create(:budget)

        sign_in(budget.user)

        get "/api/budgets/#{other_budget.id}/categories",
            headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    it 'returns the all categories within given budget', :aggregate_failures do
      category_group_one = create(:category_group, budget: budget)
      category_group_two = create(:category_group, budget: budget)
      other_category_group = create(:category_group)

      category_one = create(:category, category_group: category_group_one)
      category_two = create(:category, category_group: category_group_two)
      create(:category, category_group: other_category_group)

      allow(Api::CategorySerializer).to receive(:new)

      sign_in(budget.user)

      get "/api/budgets/#{budget.id}/categories", headers: headers

      expect(response).to have_http_status(:ok)
      expect(Api::CategorySerializer).to(
        have_received(:new).with([category_one, category_two]),
      )
    end
  end
end
