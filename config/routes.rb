Rails.application.routes.draw do
  post 'price_listings' => 'listings#pricer'
  resources :listings
  resources :cards
  resources :dards
  resources :setts
  root to: "home#index"
end
