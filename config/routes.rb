Rails.application.routes.draw do
  root "pages#demo"

  get "signup", to: "users#new"
  post "signup", to: "users#create"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  post "logout", to: "sessions#destroy"
  get "logout", to: "sessions#destroy"

  # nonce(uuid)を取ってるくAPI
  namespace :api do
    namespace :v1 do
      resources :users
    end
  end
end