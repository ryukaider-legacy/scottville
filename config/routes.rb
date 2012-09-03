Scottville::Application.routes.draw do

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets
  resources :activate, only: [:edit]

  root to: 'static_pages#home'
  
  # user/session pages
  match '/signup',  to: 'users#new'
  match '/login',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
  get '/signout' => 'sessions#destroy'
  match '/resetpassword', to: 'password_resets#new'
  match '/activation', to: 'users#activation'
  match '/activation_resend', to: 'users#activation_resend'
  match '/account', to: 'users#account'
  match '/players', to: 'users#index'
  match '/players/:id' => 'users#show'
  
  # game pages
  match '/game', to: 'game#index'
  match '/buildings', to: 'game#buildings'
  match '/buildings_submit', to: 'game#buildings_submit'
  
  # static pages
  match '/about',    to: 'static_pages#about'
  match '/contact',    to: 'static_pages#contact'
  match '/help',    to: 'static_pages#help'
  match '/patchnotes',    to: 'static_pages#patchnotes'
  match '/jsdisabled', to: 'static_pages#jsdisabled'

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
