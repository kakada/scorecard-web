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
    resources :medians
    resources :swots
    resources :indicators, module: "scorecards"
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
  resources :users

  namespace :api do
    namespace :v1 do
      resources :languages do
        get :download, on: :member
      end

      resources :scorecards, only: [:show, :update] do
        resources :languages, only: [:index]
      end
    end
  end

  mount Pumi::Engine => "/pumi"
end
