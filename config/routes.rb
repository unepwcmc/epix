Rails.application.routes.draw do
  as :user do
    patch '/user/confirmation' => 'users/confirmations#update', :via => :patch, :as => :update_user_confirmation
  end

  devise_for :users, controllers: {
    passwords: 'users/passwords',
    confirmations: 'users/confirmations'
  }
  wash_out "api/v1/soap_api"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  get 'permits/:country/:permit_identifier' => 'permits#show',
    as: 'permit',
    country: /\w\w/
  # in case country malformed
  get 'permits/:country/:permit_identifier' => redirect('permits/')
  # in case permit number not given
  get 'permits/:country' => redirect('permits/')
  resources :permits, only: [:index]

  namespace :admin do
    resources :organisations, except: [:destroy]
    resources :users
  end

  # You can have the root of your site routed with "root"
  root 'home#index'

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
