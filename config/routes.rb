Rails.application.routes.draw do
  resources :users
  resources :games
  resources :gamestates
  resources :heros
  get 'main/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'main#index'
end
