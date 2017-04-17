Rails.application.routes.draw do
  resources :books, except: :update
  resources :users, except: [:new, :index, :destroy]
  resources :sessions, only: [:create, :destroy]
  resources :users do
    resources :books, except: [:create, :show, :new]
  end
end
