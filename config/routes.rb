Rails.application.routes.draw do
  post 'price_listings' => 'listings#pricer'
  post 'value_listings' => 'listings#valuer'
  post 'csv_listings' => 'listings#csv'
  resources :listings
  resources :cards
  resources :dards
  resources :setts
  root to: "home#index"
end
