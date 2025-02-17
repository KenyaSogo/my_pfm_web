Rails.application.routes.draw do
  namespace :admin do
    get 'access_logs/index'
  end

  namespace :admin do
    get 'users/index'
  end

  namespace :admin do
    get 'users/show'
  end

  resources :acct_to_class_maps, only: [:edit, :update]
  resources :simulation_acct_classes, except: [:show]
  resources :sum_by_acct_class_settings, only: [:show]
  resources :sum_by_account_classes, except: [:index]
  resources :summary_by_asset_types, only: [:show, :edit, :update]
  resources :simulation_summary_by_accounts, only: [:show, :edit, :update]
  resources :simulation_summaries, only: [:show, :edit, :update]
  resources :billing_accounts, except: [:index]
  resources :simulation_entry_details, except: [:index]
  resources :simulation_entries, except: [:index]
  resources :simulations, except: [:index] do
    member do
      get 'generate'
      get 'generate_status'
    end
  end
  resources :asset_activities, only: [:index]
  resources :asset_accounts, only: [:show, :edit, :update]
  resources :assets do
    member do
      get 'aggregate'
      get 'aggregate_status'
    end
  end
  root 'homes#show'

  get 'homes/index'
  get 'homes/show'

  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.is_admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
