Rails.application.routes.draw do
  root 'bots#index'
  resources :bots

  get '/auth/:provider/callback', to: 'sessions#create'
  resource :sessions, only: [:new, :destroy]
end
