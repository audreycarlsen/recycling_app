RecyclingApp::Application.routes.draw do
  root "welcome#index"
  
  get "welcome/search",   to: "welcome#search"
  get "locations", to: "locations#index", as: "locations"

  resources :materials
  get "locations/match",  to: "locations#match"
end
