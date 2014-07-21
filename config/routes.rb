Packet::Application.routes.draw do
  resources :signatures, only: [:index, :update]
  resources :upperclassmen, only: [:index, :show]
  resources :freshmen, only: [:create, :destroy, :index, :show, :update]
  resources :stats, only: [:index]
  resource  :sessions, only: [:new, :create, :destroy]
  root to: "upperclassmen#show"
end
