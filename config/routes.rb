IUPB::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin' if Rails.env.development?

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
    
    match "40jahre" => "forty_years#index", :as => :fortyyears
    match "40jahre_fact" => "forty_years#random_fact", :as => :fortyyears_random_fact
    match "timetable" => "timetable#index", :as => :timetable
    get "forty_years/export"
    
    get "timetable/new"
    get "timetable/export"
    post "timetable/create"
    post "timetable/add_course"
    delete "timetable/destroy"
    delete "timetable/destroy_course"
    get "timetable/show"
    put "timetable/update"
    
    get '/sitemap', :to => 'sitemap#index', :as => :sitemap
    get '/sitemap/courses', :to => 'sitemap#courses' , :as => :course_directory
    
    #offline = Rack::Offline.configure do   
    #  public_path = Pathname.new(Rails.public_path)
    #  Dir["#{public_path.to_s}/assets/*.*", "#{public_path.to_s}/scripts/*.*", "#{public_path.to_s}/stylesheets/*.*" ].each do |file|
    #      cache("/" + Pathname.new(file).relative_path_from(public_path).to_s) if File.file?(file)
    #  end
    #  #cache "/"
    #  network "*"  
    #  network "http://search.twitter.com/*"
    #  network "http://upbapi.cloudcontrolled.com/*"
    #  network "https://upbapi.cloudcontrolled.com/*"
    #  network "http://www.google-analytics.com/*"
    #  network "https://ssl.google-analytics.com/*"
    #  network "https://search.twitter.com/*"
    #  network "http://*.newrelic.com/*"
    #end
    #match "/application.manifest" => offline, :as => :cache_manifest
    match "courses/search" => "courses#search", :as => :course_search
    match "courses/:id" => "courses#show", :as => :course
    
#    devise_scope :user do
#      get 'sign_in', :to => 'users/sessions#new', :as => :new_user_session
#      get 'sign_out', :to => 'users/sessions#destroy', :as => :destroy_user_session
#    end
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
