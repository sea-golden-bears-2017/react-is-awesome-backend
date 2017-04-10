Rails.application.routes.draw do
  resources :books, except: :update
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
