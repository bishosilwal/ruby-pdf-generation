Rails.application.routes.draw do

  get 'emails/index'

  devise_for :users

  resources :home , only: [:index,:show,:new,:create,:destroy]
  resources :share, only: [:create,:destroy ,:show]

  match 'sharedbyme', to: 'share#sharedbyme', via: [:get]
	match 'sharedwithme', to: 'share#sharedwithme', via: [:get]


  root  "home#index"
 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
