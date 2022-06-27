# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  use_doorkeeper do
    controllers token_info: "token_info"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "scorecards#index"

  devise_for :users, path: "/", controllers: { confirmations: "confirmations", omniauth_callbacks: "users/omniauth_callbacks", sessions: "sessions" }

  # https://github.com/plataformatec/devise/wiki/How-To:-Override-confirmations-so-users-can-pick-their-own-passwords-as-part-of-confirmation-activation
  as :user do
    match "/confirmation" => "confirmations#update", via: :put, as: :update_user_confirmation
  end

  resources :activity_logs, only: :index
  resources :scorecards, param: :uuid do
    put :complete, on: :member

    scope module: "scorecards" do
      resources :medians
      resources :swots
      resources :indicators
      resources :request_changes do
        put :approve, on: :member
        put :reject, on: :member
      end
    end
  end

  resources :rating_scales, only: [:index, :create]

  namespace :scorecards do
    resources :indicator_actions, only: [:update]
  end

  resources :programs do
    get :es_reindex, on: :member
  end

  scope module: :programs do
    resource :setting, only: [:show, :update]
    resources :contacts, only: [:index] do
      put :upsert, on: :collection
    end

    resources :dashboard_accessibilities, only: [:index] do
      put :upsert, on: :collection
    end

    resource :telegram_bot, only: [:show] do
      put :upsert, on: :collection
      get :help, on: :collection
    end

    resource :data_publication, only: [:show] do
      put :upsert, on: :collection
    end
  end

  resources :pdf_templates do
    get :preview
  end
  resources :messages

  scope :system do
    resources :contacts, as: :system_contacts
  end

  resources :languages

  resources :facilities do
    get :children, on: :member
    resources :indicators, module: "facilities" do
      post :clone_from_template, on: :collection
      post :clone_to_template, on: :collection
      post :import, on: :collection
    end

    resources :indicator_actions, module: "facilities", only: [] do
      post :import, on: :collection
    end
  end

  resources :indicators, only: [] do
    resources :indicator_actions, module: "facilities"
  end

  resources :templates

  resources :local_ngos do
    resources :cafs, module: "local_ngos"
    post :import, on: :collection
  end

  resource :download, only: [:show]
  resources :users do
    put :unlock_access, on: :member
    post :update_locale, on: :collection
    post :resend_confirmation, on: :member
    put :archive, on: :member
    put :restore, on: :member
  end

  resource :about, only: [:show]

  resources :primary_schools do
    post :import, on: :collection
  end

  resources :mobile_notifications, only: [:index, :new, :create]

  namespace :api do
    namespace :v1 do
      resources :programs, only: [] do
        resources :languages, only: [:index]
        resources :rating_scales, only: [:index]
      end

      resources :primary_schools, only: [:index]

      resources :contacts, only: [:index]
      resource  :mobile_tokens, only: [:update]

      resources :facilities, only: [] do
        resources :indicators, only: [:index]
      end

      resources :scorecards, only: [:show, :update] do
        resources :custom_indicators, only: [:create]
        resources :scorecard_references, only: [:create]
      end

      resources :scorecard_progresses, only: [:create]

      resources :local_ngos, only: [] do
        resources :cafs, only: [:index]
      end

      resources :users, only: [] do
        put :lock_access, on: :collection
      end

      post   "sign_in",  to: "sessions#create"
      delete "sign_out", to: "sessions#destroy"

      get "*path" => "api#routing_error"
    end
  end

  mount Pumi::Engine => "/pumi"

  # Telegram
  telegram_webhook TelegramWebhooksController

  if Rails.env.production?
    # Sidekiq
    authenticate :user, lambda { |u| u.system_admin? } do
      mount Sidekiq::Web => "/sidekiq"
    end
  else
    mount Sidekiq::Web => "/sidekiq"
  end
end
