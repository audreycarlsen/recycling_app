RecyclingApp::Application.routes.draw do
  root "welcome#index"

  resources :materials

  post "results", to: "locations#index"

  namespace :api, :defaults => { :format => 'json' } do
    get "locations", to: "locations#index"
    get "materials", to: "materials#index"
  end
end
