# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             path: 'api',
             controllers: { sessions: 'api/sessions' },
             defaults: { format: :json }

  namespace :api, constraints: { format: :json } do
    get 'me', to: 'me#show'

    resources :accounts, only: %i[create index show]
    resources :budgets, only: %i[create index show]
    resources :users, only: %i[create]
  end
end
