Rails.application.routes.draw do

  # Registration
  get "register" => "register#new", as: "register"
  post "register" => "register#create", as: "new_registration"

  # Projects
  resources :projects

  # Users
  # resources :users
end
