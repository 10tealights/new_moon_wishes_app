Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  root to: 'static_pages#top'
  get '/menu', to: 'static_pages#menu'
  get '/login', to: 'user_sessions#new'
  post '/login', to: 'user_sessions#create'
  delete '/logout', to: 'user_sessions#destroy'
  post '/guest_login', to: 'guest_sessions#create'
  resources :users, only: %i[new create edit update destroy]
  resource :profile, only: %i[show edit update]
  resources :password_resets, only: %i[new create edit update]
  resources :wishes, only: %i[index new create edit update destroy]
  resources :reflections, only: %i[edit update]
  resources :cheers, only: %i[index create]
  resources :oauths, only: %i[destroy]
  resources :line_notifications, only: %i[update]

  post 'oauth/callback', to: 'oauths#callback'
  get 'oauth/callback', to: 'oauths#callback'
  get 'oauths/oauth', to: 'oauths#oauth', as: :auth_at_provider
end
