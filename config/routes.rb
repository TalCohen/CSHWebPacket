Packet::Application.routes.draw do
  resources :signatures, only: [:index, :update]
  resources :upperclassmen, only: [:index, :show]
  resources :freshmen, only: [:create, :destroy, :index, :show, :update]
  resources :stats, only: [:index]
  root to: "upperclassmen#show"
end
