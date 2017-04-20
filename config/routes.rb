Rails.application.routes.draw do
  resources :users, except: [:new, :index, :destroy, :show]
  resources :sessions, only: [:create, :destroy]

  resources :foods, except: :update
  resources :books, except: :update
  resources :users do
    resources :books, except: [:create, :show, :new]
    resources :friends, only: [:index, :create, :destroy]
  end
  resources :products, only: :index
end
