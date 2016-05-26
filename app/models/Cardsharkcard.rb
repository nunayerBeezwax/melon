class Cardsharkcard < ActiveRecord::Base

  def self.find_deals
    deals = []
    Cardsharkcard.all.each do |c|
      if !["Alpha", "Beta", "Legends", "Arabian Nights", "Antiquities", "Unlimited"].include?(c.set)
        card = c.find_card
        begin
          if card.first.value && c.foil_quantity == 0
            if (card.first.value > (c.price * 1.5)) && (card.first.value > 0.25)
              deals << c
            end
          end
        rescue
          next
        end
      end
    end
    File.open("deals.rb", "w") do |f|
      f.write(deals)
    end
    deals
  end

  def self.deals_by_seller(sellers)
    (sellers_array.inject(Hash.new(0)) {|hash,word| hash[word] += 1; hash }).sort_by(&:last).reverse
  end

  def self.potential(sellers, deals)
    potential_value = {}
    sellers.each do |s|
      seller_gain = 0
      deals.each do |d|
        if d.seller == s
          seller_gain += ((d.find_card.first.value * d.quantity) - (d.price * d.quantity))
        end
      end
      potential_value[s] = seller_gain
    end
    potential_value
  end

  def self.cost(deals)
    cost = 0
    deals.each {|d| cost += (d.price * d.quantity)}
    cost
  end

  def self.value(deals)
    value = 0
    deals.each {|d| value += (d.find_card.first.value * d.quantity)}
    value
  end

  def find_card
    Card.where(name: name, setname: set)
  end

end