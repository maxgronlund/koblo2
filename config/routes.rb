Koblo2::Application.routes.draw do 
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
      get :purchase
      get :studio
    end
  end

  resources :pages
  match '/pages/:slug' => 'pages#show'

  match '/payments/new'
  match '/adyen/notify'

  root :to => "home#index"
end
