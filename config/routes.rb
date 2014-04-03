RecyclingApp::Application.routes.draw do
  root "welcome#index"
  
  get "locations", to: "locations#index", as: "locations"
end
