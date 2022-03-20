# https://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  resources :games, except: %i[edit update] do
    put "join", to: "games#join", as: :join
    put "start", to: "games#start", as: :start
    get "poll", to: "games#poll", as: :poll
    delete "leave", to: "games#leave", as: :leave
  end

  resources :users

  get "sign-in", to: "sessions#new", as: :new_session
  post "sign-in", to: "sessions#create", as: :create_session
  delete "sign-out", to: "sessions#destroy", as: :destroy_session
  root "games#index"
end
