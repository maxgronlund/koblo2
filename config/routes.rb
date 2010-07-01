Koblo2::Application.routes.draw do |map|
  devise_for :users

  resources :users do
    resources :activities
    resources :songs
    resources :tracks
    resources :connections
  end

  resources :songs

  resources :pages
  map.pages '/pages/:slug', :controller => 'pages', :action => 'show'

  map.share '/users/:user_id/songs/:song_id/share', :controller => 'songs', :action => 'share'

  root :to => "home#index"
end
