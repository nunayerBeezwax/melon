class ListingsController < ApplicationController

  def index
    @listings = Listing.all
  end

  def new
    @listing = Listing.new
  end

  def show
    @listing = Listing.find_by_id(params[:id])
  end

  def create
    @listing = Listing.create(listing_params)
  end

  private

  def listing_params
    params.require(:listing).permit(:card, :series, :number, :quantity, :price, :pic_url, :category, :condition)
  end

end