Packet::Application.routes.draw do
  resources :signatures, only: [:index, :create, :destroy]
  resources :upperclassmen, only: [:index, :show, :update]
  resources :freshmen, only: [:create, :destroy, :index, :show, :update, :edit]
  resources :stats, only: [:index]
  resource  :sessions, only: [:new, :create, :destroy]
  root to: "upperclassmen#show"
end
