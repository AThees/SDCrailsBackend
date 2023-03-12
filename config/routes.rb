Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resource :users, only: [:create]
  post "/sign-up", to: "users#create"
  post "/login", to: "users#login"
  get "/auto_login", to: "users#auto_login"
  
end
