Mindbase::Application.routes.draw do
  resources :user_preferences

  resources :trusts do
    member do
      get 'confirm'
    end
  end


  resources :authentications
  match '/auth/:provider/callback' => 'authentications#create'
  devise_for :users, :controllers => { :registrations => 'registrations' }
  devise_for :admins

  resources :users do 
    member do
      get 'send_summary', 'mind_search'
      post 'receive_mail'
    end
  end

  resources :admins

  match "/reset_counts" => "admins#reset_counts"
  match "/reset_interests" => "admins#reset_interests"
  match "/remove_user_orphans" => "admins#remove_user_orphans"
  match "/load_with_ajax" => "home#load_with_ajax"
  match "/bead_point_load" => "home#bead_point_load"
  match "/memory_browser" => "home#memory_browser"
  match "/admin" => "home#admin"
  match "/dynamic_load" => "posts#dynamic_load"
  match "/mind_search" => "users#mind_search"
  match "/receive_mail" => "users#receive_mail"
  match "/guest_login" => "authentications#guest_login"
  match "/load_per_user_interest" => "posts#load_per_user_interest"
  match "/about" => "home#about"
  
  resources :requests

  resources :memorizations do
    member do
      get 'mark_for_action', 'mark_for_completion', 'mark_for_archival'
    end
  end
  resources :enrollments

  resources :beads_posts
  resources :comments
  resources :interests do resources :beads_interests
    
  end
  resources :interests do
      member do
      get 'add_single_bead', 'adopt', 'remove_single_bead', 'preview', 'add_beads', 'load_suggestions', 'memory_search', 'remove_tab', 'switch_privacy'
    end
  end

  resources :beads_interests
  resources :beads 


  resources :posts do resources :comments
  end
  resources :posts do resources :beads_posts
  end
  resources :posts do
    member do
      post 'memorize', 'forget', 'burn'
      get 'activate', 'switch_privacy'
    end
  end

  resources :tokens,:only => [:create, :destroy]

  root :to => "home#index" 

  namespace :user do
    root :to => "home#index"
  end

  namespace :admin do
    root :to => "home#admin"
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
