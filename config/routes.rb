Chinchin2::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  # Added for subdomain direction
  require 'subdomain'
  constraints(Subdomain) do
    match '/' => 'static_pages#download'
  end

  root to: 'static_pages#home'

  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: 'sessions#failure'
  match 'signout', to: 'sessions#destroy', as: 'signout'

  match 'm', to: 'chinchins#index'
  resources :likes
  match 'unlike', to: 'likes#destroy'
  resources :views, :only => [:index, :create]

  resources :users do
    resources :likes
    resources :chinchins
  end
  resources :chinchins, :only => [:show]
  resources :leaderboards, :only => [:index]
  resources :feeds, :only => [:index]
  resources :message_rooms, :only => [:index, :show, :update] do
    resources :messages
  end

  resources :tutorials, :only => [:index]
  resources :reports, :only => [:index]
  match 'reports/:started_at/:ended_at', to: 'reports#show'
  match 'reports/csv', to: 'reports#csv'

  match 'chinchins/:id/profile_photos', to: 'chinchins#profile_photos'
  match 'register_device_token', to: 'users#register_device_token'
  match 'register_apid', to: 'users#register_apid'

  match 'make_chinchin/:id', to: 'static_pages#make_chinchin'
  match 'make_friendship', to: 'static_pages#make_friendship'
  match 'connect_users_with_chinchins', to: 'static_pages#connect_users_with_chinchins'
  match 'fetch_profile_photos', to: 'static_pages#fetch_chinchins_profile_photos'
  match 'update_chinchin_photoscount', to: 'static_pages#update_chinchin_photoscount'
  match 'update_chinchin_photos_where_no_photos', to: 'static_pages#update_chinchin_photos_where_no_photos'
  match 'fb4pp01', to: 'static_pages#fb4pp01'
  match 'stats', to: 'static_pages#stats'
  match 'download', to: 'static_pages#download'
  match 'privacypolicy', to: 'static_pages#privacy_policy'
  match 'push_test/:userId/:message', to: 'static_pages#push_test'

  # for api
  namespace :api, :defaults => {:format => 'json'}, :path => "", :constraints => {:subdomain => 'api'} do
    namespace :v1 do
      resources :chinchins
      resources :users, {:only => [:show]}
      resources :likes
    end
  end
end
