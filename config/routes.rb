Chinchin2::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  root to: 'static_pages#home'

  match 'auth/:provider/callback', to: 'sessions#create'
  match 'auth/failure', to: redirect('/')
  match 'signout', to: 'sessions#destroy', as: 'signout'

  match 'm', to: 'chinchins#index'
  # match 'm', to: 'chinchins#under_construction'
  match 'chinchins', to: 'chinchins#index'
  resources :likes
  match 'unlike', to: 'likes#destroy'
  resources :views, :only => [:index, :create]

  resources :users do
    resources :likes
    resources :chinchins
  end
  resources :chinchins, :only => [:show]
  resources :leaderboards, :only => [:index]
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

  #match 'users', to: 'users#users'
  #match 'user/:id/chinchin', to: 'users#chinchin'
  #match 'user/:id', to: 'users#profile'
  #match 'user/:userId/like/:chinchinId', to: 'users#like'
  #match 'user/:userId/like/', to: 'users#likes'

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

  # for testing

  match 'test/browse', to: 'ab_test#browse'
  match 'test/detail', to: 'ab_test#detail'
  match 'test/likes', to: 'ab_test#likes'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
