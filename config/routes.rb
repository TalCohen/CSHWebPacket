Packet::Application.routes.draw do
  resources :signatures, only: [:index, :update]
  get "upperclassmen/index"
  get "upperclassmen/show/:id" => "upperclassmen#show", as: "upperclassman_show"
  get "freshmen/index"
  post "freshmen/index" => "freshmen#create"
  get "freshmen/show/:id" => "freshmen#show", as: "freshman_show"
  root to: "upperclassmen#show"
end
