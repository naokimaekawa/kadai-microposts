Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'toppages#index'
  
  # URLを分けるため
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  
  #do endの二重構造。[URL深堀:member,collection]
  resources :users, only: [:index, :show, :new, :create] do
    member do #users/:idの先に、followingsとfollowersのURLを作成している
      get :followings
      get :followers
      get :likes
    end
    #collection do #usersの先に、searchのURLを作成可能
      #get :search
    #end
  end

  resources :microposts, only: [:create, :destroy]
  
  resources :relationships, only: [:create, :destroy]
  
  resources :like_relationships, only: [:create, :destroy]
  
end
