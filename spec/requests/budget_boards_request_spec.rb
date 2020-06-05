# frozen_string_literal: true

require 'rails_helper'

describe Api::BudgetBoardsController do
  let(:user) { create(:user) }
  let(:headers) do
    { 'Accept': 'application/json' }
  end

  describe 'POST /api/budget_boards' do
    context 'when there is no authorization' do
      it 'returns :unauthorized' do
        post '/api/budget_boards', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end

      it 'creates a new budget board', :aggregate_failures do
        user = create(:user)
        params = {
          name: 'Dummy Budget',
          currency: 'BRL',
          user_id: user.id
        }

        sign_in(user)

        expect do
          post '/api/budget_boards', headers: headers, params: params
        end.to change { BudgetBoard.count }.by(1)

        expect(BudgetBoard.last).to have_attributes(params)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /api/budget_boards/' do
    context 'when there is no authorization' do
      it 'returns :unauthorized' do
        get '/api/budget_boards', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end

    it 'returns all budget boards from current_user', :aggregate_failures do
      create(:budget_board)
      budget_board = create(:budget_board, user: user)

      allow(Api::BudgetBoardSerializer).to receive(:new)

      sign_in(user)

      get '/api/budget_boards', headers: headers

      expect(response).to have_http_status(:ok)
      expect(Api::BudgetBoardSerializer).to(
        have_received(:new).with([budget_board])
      )
    end
  end
end
