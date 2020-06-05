# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             path: 'api',
             controllers: { sessions: 'api/sessions' },
             defaults: { format: :json }

  namespace :api, constraints: { format: :json } do
    get 'me', to: 'me#show'

    resources :users, only: %i[create]
    resources :budget_boards, only: %i[create index]
  end
end
