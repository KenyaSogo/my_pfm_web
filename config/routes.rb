Rails.application.routes.draw do
  resources :acct_to_class_maps
  resources :simulation_acct_classes
  resources :sum_by_acct_class_settings
  resources :sum_by_account_classes
  resources :summary_by_asset_types
  resources :simulation_summary_by_accounts
  resources :simulation_summaries
  resources :billing_activities
  resources :billing_accounts
  resources :simulation_result_activities
  resources :simulation_entry_details
  resources :simulation_entries
  resources :simulations do
    member do
      get 'generate'
    end
  end
  resources :asset_activities
  resources :asset_accounts
  resources :assets do
    member do
      get 'aggregate'
    end
  end
  root 'homes#index'

  get 'homes/index'
  get 'homes/show'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
