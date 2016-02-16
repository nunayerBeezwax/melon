class Ebaygent
  require "csv"
  require "open-uri"
  require "capybara"

  SINGLES_SMARTHEADERS = [
    "ConditionID=3000",
    "Format=FixedPrice",
    "Duration=30",
    "Location=56686",
    "ShippingType=Flat",
    "ShipToLocations=Worldwide",
    "ShippingService-1:Option=USPSFirstClass",
    "ShippingService-1:Cost=0",
    "ShippingService-1:FreeShipping=1",
    "ShippingService-1:AdditionalCost=0",
    "IntlShippingService-1:Option=USPSFirstClassMailInternational",
    "IntlShippingService-1:Cost=2",
    "IntlShippingService-1:AdditionalCost=0",
    "IntlShippingService-1:Locations=Worldwide",
    "DispatchTimeMax=1",
    "PayPalAccepted=1",
    "PayPalEmailAddress=awkwardmelon@gmail.com",
    "RefundOption=MoneyBackOrReplacement",
    "ReturnsAcceptedOption=ReturnsAccepted",
    "ReturnsWithinOption=Days_14",
    "ShippingCostPaidByOption=Buyer"
  ]

  SINGLES_HEADERS = [
    "Action",
    "Category",
    "PicURL",
    "Title",
    "Description",
    "Quantity",
    "StartPrice"
  ]

  MTGSTOCKS_SET_EXCEPTIONS = {
    "Alpha" => "Alpha Edition",
    "Battle Royale" => "Battle Royale Box Set",
    "Beatdown" => "Beatdown Box Set",
    "Beta" => "Beta Edition",
    "6th Edition" => "Classic Sixth Edition",
    "5th Edition" => "Fifth Edition",
    "4th Edition" => "Fourth Edition",
    "Magic Core Set 2010" => "Magic 2010 (M10)",
    "Magic Core Set 2011" => "Magic 2011 (M11)",
    "Magic Core Set 2012" => "Magic 2012 (M12)",
    "Magic Core Set 2013" => "Magic 2013 (M13)",
    "Magic Core Set 2014" => "Magic 2014 (M14)",
    "Magic Core Set 2015" => "Magic 2015 (M15)",
    "Revised" => "Revised Edition",
    "Unlimited" => "Unlimited Edition"
  }


  def make_singles_csv(action)
    CSV.open("listings_#{Time.now.to_i}.csv", "wb") do |csv|
      csv << [SINGLES_HEADERS, SINGLES_SMARTHEADERS].flatten
      Listing.where(listed?: false).each do |l|
        array = [action, l.make_category, l.make_pic_url, l.make_title, l.make_description, l.quantity, l.price]
        csv << array
        # technically false, it has only been put in the csv, not put on ebay... should fix?
        l.update_column(:listed?, true) if action == "Add"
      end
    end
  end

  # have to deal with FOILS...
  # have to perfectly map my series names to theirs (i.e. 4th Edition -> Fourth Edition)

  def get_prices(listing)
    driver = Selenium::WebDriver.for(:firefox)
    driver.get("http://mtgstocks.com/sets")
    nav = driver.find_element(:class, "navbar")
    driver.execute_script("arguments[0].style.display='none'", nav)
    series = MTGSTOCKS_SET_EXCEPTIONS.keys.include?(listing.series) ? MTGSTOCKS_SET_EXCEPTIONS["#{listing.series}"] : listing.series
    set_link = driver.find_element(:link_text, series)
    set_link.click
    nav = driver.find_element(:class, "navbar")
    driver.execute_script("arguments[0].style.display='none'", nav)
    card_link = driver.find_element(:link_text, listing.card)
    card_link.click
    low = driver.find_element(:class, "low").text.gsub("$", "").to_f
    average = driver.find_element(:class, "average").text.gsub("$", "").to_f
    high = driver.find_element(:class, "high").text.gsub("$", "").to_f
    driver.close
    prices = { low: low, average: average, high: high }
    return OpenStruct.new prices
  end

  def price_listing(listing)
    tcg_prices = get_prices(listing)
    guide_price = tcg_prices.average * listing.number
    guide_price.ceil.to_f - 0.01
  end

  def batch_price(listings)
    listings.each do |l|
      temp = price_listing(l)
      temp = temp - 1 if l.condition == "EX"
      temp = temp - 2 if !["NM", "EX"].include?(l.condition)
      price = temp > 2.49 ? temp : 2.49
      l.update_column(:price, price)
    end
  end


  def current_listings(string)
    finder = Rebay::Finding.new
    response = finder.find_items_by_keywords({:keywords => string})
    #array of items (max 100?)
    response.results
    #price
    response.results.first["sellingStatus"]["currentPrice"]["__value__"].to_f
    binding.pry
  end

  def by_category(num)
    finder = Rebay::Finding.new
    response = finder.find_items_by_category({categoryId: 158756, :SortOrderType => "EndTimeSoonest"})
    binding.pry
  end

  def current_listings_by_cat(string)
    finder = Rebay::Finding.new
    response = finder.find_items_advanced({keywords: string, categoryId: 19107})
    binding.pry
    response.response['@count']
  end

  def average_price(response)
    items = response.response['searchResult']['item']
    total_price = 0
    currently_listed = response.response['searchResult']['@count'].to_i
    items.each do |item|
      num = find_count(item)
      total_price += (item['sellingStatus']['currentPrice']['__value__'].to_f / num.to_f)
    end
    (total_price / currently_listed)
  end

  def find_count(item)
    maybes = item['title'].scan(/\d/)
    mode(maybes) || "1"
  end

  def mode(a)
    a.group_by(&:itself).values.max_by(&:size).first if a.count >= 1
  end



  #ebay API Stuff
  # FindingAPI is for getting all the items you want to look at: findItemsByCategory
  # magic individual cards top level = 38292
  # bidding will be done through the TradingAPI

  def make_ebay_url(searchtype, category)
    url = ""
    url += "http://svcs.ebay.com/services/search/FindingService/v1?"
    url += "OPERATION-NAME=findItemsByCategory"
    url += "&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=HarlandH-af4d-46b8-929d-c6b0a5cacfc2"
    url += "&categoryId=38292"
    url += "&sortOrder=EndTimeSoonest" #StartTimeNewest
    url += "&itemFilter(0).name=ListingType&itemFilter(0).value(0)=Auction"
  end

  def pull_items(response)
    response["findItemsByCategoryResponse"]["searchResult"]["item"]
  end

  def gimmie_the_goods(itemarray)
    clean_items = []
    itemarray.each do |item|
      item_hash = {}
      item_hash["item_number"] = item["itemId"]
      item_hash["title"] = item["title"]
      if !item["shippingInfo"]["shippingType"] == "Calculated"
        item_hash["shipping_cost"] = item["shippingInfo"]["shippingServiceCost"]["__content__"]
      else
        item_hash["shipping_cost"] = "2.54"
      end
      item_hash["price"] = item["sellingStatus"]["currentPrice"]["__content__"]
      item_hash["end_time"] = item["listingInfo"]["endTime"]
      clean_items << item_hash
    end
    clean_items
  end

  def check_price(clean_items)
    snipes = []
    clean_items.each do |item|
      card = HTTParty.get("http://mtgscavenger.com/api/lookup?card[]=#{item['title'].gsub(/[^0-9A-Za-z]/, ' ')}")
      price = HTTParty.get("http://mtgscavenger.com/api/card_values/#{card.first['card_id'].to_s}")
      if price["dealer_mid_price"].to_f - item["price"].to_f > 5
        snipes << item
      end
    end
    snipes
  end

end