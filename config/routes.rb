Rails.application.routes.draw do
  resources :books, except: :update
  resources :users, only: [:create, :update]
  resources :sessions, only: [:create, :destroy]
end
