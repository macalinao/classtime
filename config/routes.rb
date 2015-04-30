Rails.application.routes.draw do
  get '/users/sign_in', to: redirect('/users/auth/facebook')
  get '/users/sign_up', to: redirect('/users/auth/facebook')
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root 'home#index'

  resources :schedules
  resources :users
end
