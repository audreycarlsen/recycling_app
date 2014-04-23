require 'resque/server'

RecyclingApp::Application.routes.draw do
  root "welcome#index"

  mount Resque::Server, :at => "/resque"

  resources :materials

  post "results", to: "locations#index"
  post "email",   to: "locations#email"

  namespace :api, :defaults => { :format => 'json' } do
    get "locations", to: "locations#index"
    get "materials", to: "materials#index"
  end
end
