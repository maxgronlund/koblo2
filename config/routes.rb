Koblo2::Application.routes.draw do |map|
  devise_for :users

  resources :users do
    resources :connections
    resources :songs
    resources :tracks
  end

  map.pages '/pages/:slug', :controller => 'pages', :action => 'show'
  map.share '/users/:user_id/songs/:song_id/share', :controller => 'songs', :action => 'share'

  root :to => "home#index"
end
