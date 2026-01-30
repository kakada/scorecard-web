# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq-scheduler/web"

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

  # Public voting route (no authentication required)
  resources :scorecards, only: [], param: :token do
    resources :votes, only: [:index, :new, :create, :show]
  end

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
      resources :unlock_requests do
        put :approve, on: :member
        put :reject, on: :member
      end
    end
  end

  resources :rating_scales, only: [:index, :create]

  namespace :scorecards do
    resources :indicator_activities, only: [:update]
  end

  resources :programs do
    get :es_reindex, on: :member

    resources :program_clones, only: [:show], path: "clone_wizard"

    scope :clone_wizard, as: :clone_wizard do
      get ":step", to: "clone_wizard#show", as: :step
      patch ":step", to: "clone_wizard#update"
    end
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

  resources :jaaps

  resources :languages

  resources :facilities do
    get :children, on: :member
    resources :indicators, module: "facilities" do
      post :clone_from_template, on: :collection
      post :clone_to_template, on: :collection
      post :import, on: :collection
    end
  end

  resources :templates

  resources :local_ngos do
    resources :cafs, module: "local_ngos"

    resources :caf_importers, except: [:update, :edit], param: :code do
      get :sample, on: :collection
    end
  end

  resources :local_ngo_importers, except: [:update, :edit, :destroy] do
    get :sample, on: :collection
  end

  resource :download, only: [:show]
  resources :voting_indicators, only: [:index]
  resources :users do
    put :unlock_access, on: :member
    post :update_locale, on: :collection
    post :resend_confirmation, on: :member
    put :archive, on: :member
    put :restore, on: :member
  end

  resource :about, only: [:show]
  resource :privacy_policy, only: [:show]
  resource :terms_and_conditions, only: [:show]

  resources :mobile_notifications, only: [:index, :new, :create]

  resources :scorecard_batches, except: [:update, :edit], param: :code do
    get :sample, on: :collection
  end

  resources :removing_scorecards, only: [:index, :new, :create]

  resources :categories do
    resources :datasets do
      post :import, on: :collection
    end
  end

  namespace :api do
    namespace :v1 do
      resources :programs, only: [] do
        resources :languages, only: [:index]
        resources :rating_scales, only: [:index]
      end

      resources :primary_schools, only: [:index]
      resources :datasets, only: [:index]

      resources :contacts, only: [:index]
      resource  :mobile_tokens, only: [:update]

      resources :facilities, only: [] do
        resources :indicators, only: [:index]
      end

      resources :scorecards, only: [:show, :update] do
        resources :custom_indicators, only: [:create]
        resources :scorecard_references, only: [:create]
        resource :qr_code, only: [:show], controller: "scorecards/qr_codes"
        resources :voting_results, only: [:index], module: :scorecards
        resource :poll, only: [:show], module: :scorecards
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
