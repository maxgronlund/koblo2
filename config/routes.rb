Koblo2::Application.routes.draw do |map|
  devise_for :users, :controllers => { :registrations => "registrations", :passwords => "passwords" }

  resources :users do
    resources :activities
    resources :songs
    resources :tracks
    resources :connections
    resources :pictures
  end

  resources :pictures

  resources :songs do
    member do
      get :share
      get :buy
      get :studio
    end
  end

  resources :pages
  map.pages '/pages/:slug', :controller => 'pages', :action => 'show'

  root :to => "home#index"
end
