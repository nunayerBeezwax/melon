Rails.application.routes.draw do
  post 'price_listings' => 'listings#pricer'
  resources :listings
  resources :cards
  resources :sets
  root to: "home#index"
end
