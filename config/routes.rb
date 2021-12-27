# frozen_string_literal: true

# https://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  resources :games do
    put "join", to: "games#join", as: :join
  end

  resources :users

  get "sign-in", to: "sessions#new", as: :new_session
  post "sign-in", to: "sessions#create", as: :create_session
  delete "sign-out", to: "sessions#destroy", as: :destroy_session
  root "games#index"
end
