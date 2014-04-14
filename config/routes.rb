RecyclingApp::Application.routes.draw do
  root "welcome#index"

  resources :materials

  post "results", to: "locations#index"
end
