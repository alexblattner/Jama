Rails.application.routes.draw do
  resources :levels
  resources :heroes
  resources :users
  resources :games
  resources :gamestates
  resources :sessions
  get  '/gamestate', to: 'gamestates#save'
  get 'main/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'main#index'
  
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get  '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  get '/games', to: 'games#index'
  get '/publishedgames', to: 'games#published'

end
