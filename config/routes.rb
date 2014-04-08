RecyclingApp::Application.routes.draw do
  root "welcome#index"
  
  get "welcome/search",   to: "welcome#search"

  resources :materials
  resources :locations

  get "locations/distances", to: "locations#calculate_distances"
end
