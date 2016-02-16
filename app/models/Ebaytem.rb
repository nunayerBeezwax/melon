class Ebaytem < ActiveRecord::Base

  def snipe
    # send self.item_number and bid to sniper
    # in some brain somewhere: Ebaytems.all.where(:active).each { item.snipe if item_worth_sniping(item) }
  end

  def attributes
    item_number
    current_price
    melon_listing_value
    end_time
    shipping_cost
    item_title
    worth_to_me
    snipe_set?
    bid_on?
    won?
    received?
    i_sold_it_for
  end
end