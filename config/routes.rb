# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "dashboard#show"

  devise_for :users, path: "/", controllers: { confirmations: "confirmations", omniauth_callbacks: "users/omniauth_callbacks" }

  # https://github.com/plataformatec/devise/wiki/How-To:-Override-confirmations-so-users-can-pick-their-own-passwords-as-part-of-confirmation-activation
  as :user do
    match "/confirmation" => "confirmations#update", via: :put, as: :update_user_confirmation
  end

  resources :scorecards do
    scope module: "scorecards" do
      resources :medians
      resources :swots
      resources :indicators
    end
  end

  resources :programs

  scope module: :programs do
    resource :setting, only: [:show, :update]
  end

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
    resources :cafs, module: "local_ngos"
    post :import, on: :collection
  end

  resource :download, only: [:show]
  resources :scorecard_types
  resources :users do
    collection do
      post :update_locale
    end
  end

  namespace :api do
    namespace :v1 do
      resources :programs, only: [] do
        resources :languages, only: [:index]
      end

      resources :categories, only: [] do
        resources :indicators, only: [:index]
      end

      resources :scorecards, only: [:show, :update] do
        resources :custom_indicators, only: [:create]
      end

      resources :local_ngos, only: [] do
        resources :cafs, only: [:index]
      end

      post   "sign_in",  to: "sessions#create"
      delete "sign_out", to: "sessions#destroy"
    end
  end

  mount Pumi::Engine => "/pumi"
end
