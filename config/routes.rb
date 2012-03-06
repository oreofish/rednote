Rednote::Application.routes.draw do


  resources :projects do
    collection do
      get 'knowledgebase'
    end
  end

  resources :debits
  match 'debits/unwaiting', :to => 'debits#unwaiting'
  resources :books
  get "books/wait"
  match 'books/borrow', :to => 'books#borrow'

  mount Ckeditor::Engine => '/ckeditor'
  match 'comments/dono', :to => 'comments#dono'
  resources :comments

  match 'likes/create', :to => 'likes#create'
  match 'likes/update', :to => 'likes#update'
  match 'likes/destroy', :to => 'likes#destroy'



  devise_for :users

  get "users/search_nickname"
  get "users/search_email"
  get "users/page"
  get "users/avatar"
  get "users/mycomments"
  get "users/nickname"
  get "users/mytags"
  get "users/crop_update"
  match '/users', :to => 'users#index'
  match ':users/crop_update' => 'users#crop_update'
  match ':users/avatar', :to  => 'users#update', :as => :user 

  root :to => "notes#index"

  resources :notes do
    collection do
      get 'page'
    end
  end

  match '/mails', :to => 'mails#index'
  match '/mails/interview', :to => 'mails#interview'
  match '/mails/invite', :to => 'mails#invite'

  resources :tasks do
    collection do
      get 'history'
      get  'set_status'
      post 'set_tag'
    end
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
