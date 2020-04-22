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
  get   'level-doors/:id', to: 'levels#doors'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  get  '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/gamestates/reset/:id', to: 'gamestates#reset'
  get '/gamestates/partial/:id', to: 'gamestates#partial'
  get '/games', to: 'games#index'
  get '/publishedgames', to: 'games#published'
  get '/doors/open/:id', to: 'doors#open'
  #game creation
  get '/creategame', to: 'games#new'
  get '/allgames', to: 'games#all'
  get '/addlevel/:game_id' , to: 'levels#new', as: 'addlevel'
  get '/addevent/:game_id' , to: 'events#new', as: 'addevent'
  get '/adddoor/:game_id' , to: 'doors#new', as: 'adddoor'

  get 'editevent/:game_id/:id', to: 'events#edit', as: 'editevent'
  get 'editlevel/:game_id/:level_id', to: 'levels#organizeevents', as: 'editlevel'
  get 'editdoor/:game_id/:id', to: 'doors#edit', as: 'editdoor'

  get '/assigneventforone/:game_id/:level_id', to: 'levels#assigneventforone', as: 'assigneventforone'
  get '/queueevent/:game_id/:level_id/:event_id', to: 'levels#queueevent', as: 'queueevent'
  get '/dequeueevent/:game_id/:level_id', to: 'levels#dequeueevent', as: 'dequeueevent'

  get '/assigndoorforone/:game_id/:level_id', to: 'levels#assigndoorforone', as: 'assigndoorforone'
  get '/queuedoor/:game_id/:level_id/:door_id', to: 'levels#queuedoor', as: 'queuedoor'
  get '/dequeuedoor/:game_id/:level_id', to: 'levels#dequeuedoor', as: 'dequeuedoor'

  get '/assignlevelforone/:game_id/:door_id', to: 'doors#assignlevelforone', as: 'assignlevelforone'
  get '/queuelevel/:game_id/:door_id/:level_id', to: 'doors#queuelevel', as: 'queuelevel'
  get '/dequeuelevel/:game_id/:door_id', to: 'doors#dequeuelevel', as: 'dequeuelevel'

  get '/assigneventforall/:game_id', to: 'levels#assigneventforall', as: 'assigneventforall'
  get '/creategamelogic/:game_id', to: 'levels#creategamelogic', as: 'creategamelogic'
  get '/organize/:game_id' , to: 'levels#organize', as: 'organizelevel'
  get 'designatestart/:game_id', to: 'levels#designatestart', as: 'designatestart'
  get '/levels/dashboard/:game_id', to: 'levels#dashboard', as: 'leveldashboard'
  get '/startinglevel/:game_id/:level_id', to: 'games#startinglevel', as: 'startinglevel'
end
