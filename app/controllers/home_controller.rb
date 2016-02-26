class HomeController < ApplicationController
  def index
    @cards = Card.order('value DESC')[0..9]
  end
end