Rails.application.routes.draw do
  devise_for :users

  resources :home
  resources :share, only: [:create,:destroy ,:show]
  resources :folder, only: [:index,:create,:destroy,:update,:show]
  match 'sharedbyme', to: 'share#sharedbyme', via: [:get]
	match 'sharedwithme', to: 'share#sharedwithme', via: [:get]
	match 'sharefolder',to: 'share#sharefolder',via: [:post]
	match 'unsharefolder',to: 'share#unsharefolder', via: [:delete]

  match 'appendfolder',to: 'folder#appendfolder',via: [:post]
  match 'appendfile',to: 'folder#appendfile',via: [:post]
  match 'uploadfolder', to: "home#createdocumentwithfolder", via: [:post]
  match 'folderpassword',to: 'folder#folderpassword',via: [:post]
  match 'showfolder',to: 'folder#openfolder',via: [:post,:get]
  match 'folderdownload',to: "folder#folderdownload",via:[:post,:get]


  root  "home#index"
 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
