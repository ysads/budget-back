# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api, constraints: { format: :json } do
    get 'me', to: 'me#show'

    resources :budgets, only: %i[create index show] do
      resources :accounts, only: %i[create index show]
      resources :categories, only: %i[create index]
      resources :category_groups, only: %i[create index]
      resources :months, only: %i[show], param: :iso_month
      resources :monthly_budgets, only: %i[create index update]
      resources :payees, only: %i[index]
      resources :transactions, only: %i[create index update]
      resources :transfers, only: %i[create] do
        collection do
          put :update
        end
      end
    end

    resources :users, only: %i[create]
  end
end
