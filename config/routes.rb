Rails.application.routes.draw do
  resources :doors
  resources :event_instances
  resources :events
  resources :heroes
  resources :levels
  resources :games
  resources :heroes
  resources :packages
  resources :doors
  resources :users
  resources :gamestates
  resources :sessions
  get  '/gamestate', to: 'gamestates#save'
  get 'main/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'main#index'
  #post 'levels/doors', to: 'levels#doors'
  get   'level-doors/:level', to: 'levels#doors'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get  '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  get '/games', to: 'games#index'
  get '/publishedgames', to: 'games#published'
  
  #game creation
  get '/creategame', to: 'games#new'
  get '/allgames', to: 'games#all'
  get '/addlevel/:game_id' , to: 'levels#new', as: 'addlevel'
  get '/addevent/:game_id' , to: 'events#new', as: 'addevent'
  get '/adddoor/:game_id' , to: 'doors#new', as: 'adddoor'

  get 'editevent/:game_id/:id', to: 'events#edit', as: 'editevent'
  get 'editlevel/:game_id/:level_id', to: 'levels#organizeevents', as: 'editlevel'
  get 'editdoor/:game_id/:id', to: 'doors#edit', as: 'editdoor'

  get '/assignevent/:game_id', to: 'levels#assignevent', as: 'assignevent'
  get '/organize/:game_id' , to: 'levels#organize', as: 'organizelevel'
  get '/levels/dashboard/:game_id', to: 'levels#dashboard', as: 'leveldashboard'
end
