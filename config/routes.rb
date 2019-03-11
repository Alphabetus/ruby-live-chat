Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # resources from DB & relations
  resources :users, :messages

  # websockets
  mount ActionCable.server => '/cable'

  # routing
  get "/account" => "pages#account"
  post "/account" => "users#update"
  post "/account/password" => "users#update_password"
  post "/account/delete" => "users#destroy"

  get "/chat" => "pages#chat"
  get "/chat/:chat" => "pages#chat"
  post "/chat/:chat" => "messages#create"

  get "/signup" => "users#new"
  post "/signup" => "users#create"


  get "/login" => "sessions#new"
  post "/login" => "sessions#create"

  get "/logout" => "sessions#destroy"

  # landing page
  root "pages#index"

end
