Rails.application.routes.draw do
  resources :books, except: :update
  resources :users, only: :create
  resources :sessions, only: [:create, :destroy]
end
