Rails.application.routes.draw do

  get 'search/search'
  # get 'relationships/create'
  # get 'relationships/destroy'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to:'homes#top'

  resources:books,only:[:new,:create,:index,:show,:destroy,:edit,:update]do
    resource:favorites,only:[:create,:destroy]
    resources:book_comments,only:[:create,:destroy]
  end
  

# roomのcrearte and show 
# messageはcreate

  resources :users, only: [:show,:edit,:update,:index]do
      resource :relationships, only: [:create, :destroy]
  get 'followings' => 'relationships#followings', as: 'followings'
  get 'followers' => 'relationships#followers', as: 'followers'
 end
 
  

  get'home/about' =>'homes#about'
  get '/search' => 'search#search'
  # get'users' =>'users#index
  resources :messages, :only => [:create]
  resources :rooms, :only => [:create, :show]
  end
