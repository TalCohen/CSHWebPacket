Packet::Application.routes.draw do
  get "signatures/update"
  get "signatures/index"
  get "upperclassmen/index"
  get "upperclassmen/show/:id" => "upperclassmen#show", as: "upperclassman_show"
  get "freshmen/index"
  get "freshmen/show/:id" => "freshmen#show", as: "freshman_show"
  root to: "signatures#index"
  resource :packet
  #upperclassman_show_path(@upperclassman) # => "/upperclassmen/show/345"
end
