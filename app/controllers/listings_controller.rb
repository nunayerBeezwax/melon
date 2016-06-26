class ListingsController < ApplicationController

  # TODO: make validations for listing_params - right now it doesn't break on save if mistake happens

  def index
    @listings = Listing.where(listed?: false)
    @current_value = @listings.map{ |p| ( p.price || 0 ) * p.quantity}.inject(0, :+)
    @current_quantity = @listings.map{ |p| ( p.quantity || 0 ) }.inject(:+)
  end

  def new
    @listing = Listing.new
    @listing.listing_type = params["listing_type"] if params["listing_type"]
  end

  def create
    if listing_params['listing_type'] == 'lot'
      @listing = Listing.create(listing_params)
      @listing.update_attribute(:listing_type, 'lot')
    else
      card = Card.where(name: listing_params['title'], setname: listing_params['series']).first
      @listing = Listing.create(listing_params)
      @listing.cards << card
    end
    redirect_to listings_url
  end

  def show
    @listing = Listing.find_by_id(params[:id])
    render :layout => false
  end

  def pricer
    a = Ebaygent.new
    a.batch_price(Listing.where(price: nil))
    redirect_to listings_path
  end

  def valuer
    a = Ebaygent.new
    a.batch_value(Listing.where(price: nil))
    redirect_to listings_path
  end

  def csv
    a = Ebaygent.new
    # kludge
    if Listing.where(listed?: false).last.listing_type == "auction"
      a.make_auction_csv("Add")
    elsif Listing.where(listed?: false).last.listing_type == "lot"
      a.make_lot_csv("Add")
    else
      a.make_singles_csv("Add")
    end
    redirect_to listings_path
  end

  private

  def listing_params
    params.require(:listing).permit(:listing_type, :notes, :title, :series, :number, :quantity, :price, :condition, :foil)
  end

end