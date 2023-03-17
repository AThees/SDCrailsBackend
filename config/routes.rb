Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html


  # User related routes
  resource :users, only: [:create, :destroy]
  post "/login", to: "users#login"
  get "/auto_login", to: "users#auto_login"
################################################

  # Post related routes
  resources :post, only: [:create, :index, :destroy]
  
  
end
