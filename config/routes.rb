Koblo2::Application.routes.draw do |map|
  devise_for :users

  map.resources :users
  map.resources :connections

  map.pages '/pages/:slug', :controller => 'pages', :action => 'show'

  root :to => "home#index"
end
