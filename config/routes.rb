Koblo2::Application.routes.draw do |map|
  devise_for :users

  map.resources :users

  root :to => "home#index"
end
