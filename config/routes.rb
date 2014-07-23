PostitTemplate::Application.routes.draw do
  root to: 'posts#index'

  get '/login', to: 'sessions#new', as: 'login'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy', as: 'logout'

  resources :posts, except: :destroy do
    resources :comments, only: [:create]
  end

  resources :categories, only: [:new, :create, :show]

end
