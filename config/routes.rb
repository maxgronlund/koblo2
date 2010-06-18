Koblo2::Application.routes.draw do |map|
  devise_for :users

  resources :users do
    resources :connections
  end

  map.pages '/pages/:slug', :controller => 'pages', :action => 'show'

  root :to => "home#index"
end
