PostitTemplate::Application.routes.draw do
  root to: 'posts#index'

  get '/login', to: 'sessions#new', as: 'login'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy', as: 'logout'

  get '/register', to: 'users#new', as: 'register'

  #resources :votes, only: [:create]

  resources :users, only: [:show, :create, :edit, :update]

  resources :posts, except: :destroy do
    member do
      post :vote  # /posts/3/vote
    end

    # Use 'collection' for routes that don't pertain to a specific post
    # collection do
    #   get 'archives'  # /posts/archives
    # end

    resources :comments, only: [:create]
  end

  resources :categories, only: [:new, :create, :show]

end
