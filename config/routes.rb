Rails.application.routes.draw do

  get 'observation/index'

  get 'observation/create'

  get 'users_pages/index', as: 'iup'
  # get 'user_pages'

  get 'users_pages/show'

  get 'users_pages/create'

  post 'users_pages/index', to: 'users_pages#observe'
  get 'users_pages/new', to: 'users_pages#new', as: 'new_users_pages'
  post 'users_pages/create', to:'users_pages#create', as: 'create_users_pages'

  # resources :users_pages do
  # collection do
  #     post 'users_pages/Index'
  #   end
  # end

  get '/comparator_results' => 'comparator#comparator_results'
  resources :comparator

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  # root ''  get '/login' => 'sessions#new'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  get '/users' => 'users#index'

  get '/api' => 'api#index'
  post '/api' => 'api#create'
  get 'access/:token/content/:type', to: 'api#content_access'
  get 'access/:token/content/:type/:which', to: 'api#content_access'
  get 'access/content/:actor/:type', to: 'api#content_access'
  # resources :api

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
