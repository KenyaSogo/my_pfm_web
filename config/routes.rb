Rails.application.routes.draw do
  resources :asset_activities
  resources :asset_accounts
  resources :assets
  root 'homes#index'

  get 'homes/index'
  get 'homes/show'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
