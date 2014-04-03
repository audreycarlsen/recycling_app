RecyclingApp::Application.routes.draw do
  root "locations#index"
  
  get "locations", to: "locations#index", as: "locations"
end
