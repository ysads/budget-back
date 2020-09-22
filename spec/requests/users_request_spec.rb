# frozen_string_literal: true

require 'rails_helper'

describe Api::UsersController do
  let(:headers) do
    { 'Accept': 'application/json' }
  end

  describe 'POST /api/users' do
    it 'creates a new budget board', :aggregate_failures do
      params = {
        name: 'Dummy User',
        email: 'dummy@mail.com',
        password: '123456',
      }

      expect do
        post '/api/users', headers: headers, params: params
      end.to change { User.count }.by(1)

      expect(User.last).to have_attributes(
        name: 'Dummy User',
        email: 'dummy@mail.com',
      )
      expect(response).to have_http_status(:ok)
    end
  end
end
