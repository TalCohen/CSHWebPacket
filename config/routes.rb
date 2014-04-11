Packet::Application.routes.draw do
  get "stats/index"
  resources :signatures, only: [:index, :update]
  get "upperclassmen/index"
  get "upperclassmen/show/:id" => "upperclassmen#show", as: "upperclassman_show"
  get "freshmen/index"
  post "freshmen/index" => "freshmen#create"
  get "freshmen/show/:id" => "freshmen#show", as: "freshman_show"
  delete "freshmen/show/:id" => "freshmen#destroy"
  root to: "upperclassmen#show"
end
