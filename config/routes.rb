Rails.application.routes.draw do
  devise_for :users

  resources :home
  resources :share, only: [:create,:destroy ,:show]
  resources :folder, only: [:index,:create,:destroy,:show,:update]
  match 'sharedbyme', to: 'share#sharedbyme', via: [:get]
	match 'sharedwithme', to: 'share#sharedwithme', via: [:get]
	match 'sharefolder',to: 'share#sharefolder',via: [:post]
	match 'unsharefolder',to: 'share#unsharefolder', via: [:delete]


  root  "home#index"
 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
