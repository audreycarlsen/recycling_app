RecyclingApp::Application.routes.draw do
  root "welcome#index"
  
  get "welcome/search",   to: "welcome#search"

  resources :materials
  resources :locations
end
