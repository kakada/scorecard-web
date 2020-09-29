# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "dashboard#show"

  devise_for :users, path: "/", controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
end
