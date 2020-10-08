# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "dashboard#show"

  devise_for :users, path: "/", controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  resources :scorecards do
    resources :issues
    resources :medians
    resources :swots
  end

  namespace :api do
    namespace :v1 do
      resources :languages do
        get :download, on: :member
      end
    end
  end
end
