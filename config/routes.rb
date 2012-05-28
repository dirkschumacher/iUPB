IUPB::Application.routes.draw do
  scope "(:locale)", :locale => /de|en/ do
    devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
    match "events" => 'events#index', :as => :events
    match "asta" => 'asta#index', :as => :asta
    match "asta/data" => 'asta#data', :as => :asta_data
    match "restaurants" => 'restaurants#index', :as => :restaurants
    match "restaurants/:restaurant" => 'restaurants#index', :as => :restaurant
    match 'transportation' => 'pages#show', :id => 'transportation', :as => :transportation
    match 'weather' => 'weather#index', :as => :weather
    match 'twitter' => 'pages#show', :id => 'twitter', :as => :twitter
    match 'courses' => 'courses#index', :as => :courses
    
    get '/sitemap', :to => 'sitemap#index', :as => :sitemap
    get '/sitemap/courses', :to => 'sitemap#courses' , :as => :course_directory
  
    match "courses/search/:query" => "courses#search", :as => :course_search
    match "courses/:id" => "courses#show", :as => :course
    
    devise_scope :user do
      get 'sign_in', :to => 'users/sessions#new', :as => :new_user_session
      get 'sign_out', :to => 'users/sessions#destroy', :as => :destroy_user_session
    end
    #resource :courses
    #match 'twitter' => 'high_voltage/pages#show', :id => 'twitter'
    
    match "/pages/*id" => 'pages#show', :as => :page, :format => false
    root :to => 'pages#show', :id => 'index'
  end

  
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
