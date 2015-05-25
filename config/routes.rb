Rails.application.routes.draw do
  root 'bots#index'
  resources :bots do
    member do
      get :storage, to: 'bots#show_storage'
    end
  end

  resources :bot_modules

  get '/auth/:provider/callback', to: 'sessions#create'
  resource :sessions, only: [:new, :destroy]
end
