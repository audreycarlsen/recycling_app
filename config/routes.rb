RecyclingApp::Application.routes.draw do
  root "welcome#index"

  resources :materials

  post "locations", to: "locations#index"
end
