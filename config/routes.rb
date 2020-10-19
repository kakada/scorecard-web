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

  resources :programs
  resources :languages
  resources :categories do
    get :children, on: :member
    resources :indicators, module: "categories" do
      post :clone_from_template, on: :collection
      post :clone_to_template, on: :collection
    end
  end

  resources :templates do
    resources :indicators, module: "templates"
  end

  resources :local_ngos do
    resources :cafs
  end

  resource :download, only: [:show]
  resources :scorecard_types

  namespace :api do
    namespace :v1 do
      resources :languages do
        get :download, on: :member
      end
    end
  end

  mount Pumi::Engine => "/pumi"
end
