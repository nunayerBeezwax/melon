class ListingsController < ApplicationController

  # TODO: make validations for listing_params - right now it doesn't break on save if mistake happens

  def index
    @listings = Listing.where(listed?: false)
    @current_value = @listings.map{ |p| ( p.price || 0 ) * p.quantity}.inject(0, :+)
  end

  def new
    @listing = Listing.new
  end

  def show
    @listing = Listing.find_by_id(params[:id])
  end

  def create
    @listing = Listing.create(listing_params)
    redirect_to :root
  end

  def pricer
    a = Ebaygent.new
    a.batch_price(Listing.where(price: nil))
    redirect_to :root
  end

  private

  def listing_params
    params.require(:listing).permit(:card, :series, :number, :quantity, :price, :pic_url, :color, :condition)
  end

end