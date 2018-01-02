Rails.application.routes.draw do

  devise_for :users

  resources :home , only: [:index,:show,:new,:create,:destroy]
  root  "home#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
