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

  # can't deal with [Duel Decks: Blessed vs. Cursed, Miscellaneous Promos, Special Occasion]
  MTGSTOCKS_TO_MTGJSON = {
    "10th Edition" => "Tenth Edition",
    "7th Edition" => "Seventh Edition",
    "8th Edition" => "Eighth Edition",
    "9th Edition" => "Ninth Edition",
    "Alpha Edition" => "Limited Edition Alpha",
    "Beta Edition" => "Limited Edition Beta",
    "Champs Promos" => "Champs and States",
    "Conspiracy" => "Magic: the Gathering-Conspiracy",
    "FNM Promos" => "Friday Night Magic",
    "Game Day Promos" => "Magic Game Day",
    "Gateway Promos" => "Gateway",
    "Grand Prix Promos" => "Grand Prix",
    "Judge Promos" => "Judge Gift Program",
    "Launch Party Cards" => "Launch Parties",
    "Magic 2010 (M10)" => "Magic 2010",
    "Magic 2011 (M11)" => "Magic 2011",
    "Magic 2012 (M12)" => "Magic 2012",
    "Magic 2013 (M13)" => "Magic 2013",
    "Magic 2014 (M14)" => "Magic 2014",
    "Magic 2015 (M15)" => "Magic 2015",
    "Media Promos" => "Media Inserts",
    "Modern Event Deck" => "Modern Event Deck 2014",
    "Prerelease Cards" => "Prerelease Events",
    "Pro Tour Promos" => "Pro Tour",
    "Ravnica" => "Ravnica: City of Guilds",
    "Release Event Cards" => "Release Events",
    "WPN Promos" => "World Magic Cup Qualifiers",
    "Zendikar Expedition" => "Zendikar Expeditions"
  }

  # can't deal with [Duel Decks: Blessed vs. Cursed, Miscellaneous Promos, Special Occasion]
  TCGPLAYER_TO_MTGJSON = {
    "Ravnica" => "Ravnica: City of Guilds",
    "Magic 2010 (M10)" => "Magic 2010",
    "Magic 2011 (M11)" => "Magic 2011",
    "Magic 2012 (M12)" => "Magic 2012",
    "Magic 2013 (M13)" => "Magic 2013",
    "Magic 2014 (M14)" => "Magic 2014",
    "Magic 2015 (M15)" => "Magic 2015",
    "Sixth Edition" => "Classic Sixth Edition",
    "Alpha Edition" => "Limited Edition Alpha",
    "Beta Edition" => "Limited Edition Beta",
    "Anthology" => "Duel Decks: Anthology",
    "Zendikar vs. Eldrazi" => "Duel Decks: Zendikar vs. Eldrazi",
    "Elspeth vs. Kiora" => "Duel Decks: Elspeth vs. Kiora",
    "Speed vs. Cunning" => "Duel Decks: Speed vs. Cunning",
    "Ajani vs. Nicol Bolas" => "Duel Decks: Ajani vs. Nicol Bolas",
    "Divine vs. Demonic" => "Duel Decks: Divine vs. Demonic",
    "Elspeth vs. Tezzeret" => "Duel Decks: Elspeth vs. Tezzeret",
    "Elves vs. Goblins" => "Duel Decks: Elves vs. Goblins",
    "Garruk vs. Liliana" => "Duel Decks: Garruk vs. Liliana",
    "Heroes vs. Monsters" => "Duel Decks: Heroes vs. Monsters",
    "Izzet vs. Golgari" => "Duel Decks: Izzet vs. Golgari",
    "Jace vs. Chandra" => "Duel Decks: Jace vs. Chandra",
    "Jace vs. Vraska" => "Duel Decks: Jace vs. Vraska",
    "Knights vs. Dragons" => "Duel Decks: Knights vs. Dragons",
    "Sorin vs. Tibalt" => "Duel Decks: Sorin vs. Tibalt",
    "Venser vs. Koth" => "Duel Decks: Venser vs. Koth",
    "PDS: Graveborn" => "Premium Deck Series: Graveborn",
    "PDS: Fire and Lightning" => "Premium Deck Series: Fire and Lightning",
    "PDS: Slivers" => "Premium Deck Series: Slivers",
    "Champs Promos" => "Champs and States",
    "FNM Promos" => "Friday Night Magic",
    "Game Day Promos" => "Magic Game Day",
    "Gateway Promos" => "Gateway",
    "Grand Prix Promos" => "Grand Prix",
    "Judge Promos" => "Judge Gift Program",
    "Launch Party Cards" => "Launch Parties",
    "Media Promos" => "Media Inserts",
    "Guru Lands" => "Guru",
    "European Lands" => "Eurpoean Land Program",
    "JSS/MSS Promos" => "Super Series",
    "Magic Modern Event Deck" => "Modern Event Deck 2014",
    "Prerelease Cards" => "Prerelease Events",
    "Pro Tour Promos" => "Pro Tour",
    "Ravnica" => "Ravnica: City of Guilds",
    "Release Event Cards" => "Release Events",
    "WPN Promos" => "World Magic Cup Qualifiers"
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
    begin
      foil = driver.find_element(:class, "foilprice").text.gsub("$", "").to_f
    rescue Selenium::WebDriver::Error::NoSuchElementError
      foil = "No Foil Exists"
    end
    driver.close
    prices = { low: low, average: average, high: high, foil: foil }
    return OpenStruct.new prices
  end

  def price_card_from_db(card)
    driver = Selenium::WebDriver.for(:firefox)
    driver.get("http://mtgstocks.com/sets")
    nav = driver.find_element(:class, "navbar")
    driver.execute_script("arguments[0].style.display='none'", nav)
    series = MTGSTOCKS_SET_EXCEPTIONS.keys.include?(card.set) ? MTGSTOCKS_SET_EXCEPTIONS["#{card.set}"] : card.set
    set_link = driver.find_element(:link_text, series)
    set_link.click
    nav = driver.find_element(:class, "navbar")
    driver.execute_script("arguments[0].style.display='none'", nav)
    card_link = driver.find_element(:link_text, card.name)
    card_link.click
    low = driver.find_element(:class, "low").text.gsub("$", "").to_f
    average = driver.find_element(:class, "average").text.gsub("$", "").to_f
    high = driver.find_element(:class, "high").text.gsub("$", "").to_f
    driver.close
    prices = { low: low, average: average, high: high }
    card.update_column(:value, prices[:average])
    return OpenStruct.new prices
  end

  def price_listing(listing)
    tcg_prices = get_prices(listing)
    if !listing.foil
      guide_price = tcg_prices.average * listing.number
    else
      guide_price = tcg_prices.foil * listing.number
    end
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

  def price_a_set(setname)

  end




## stealing TCGPlayer API calls through magiccards.info = mech.get("http://partner.tcgplayer.com/x3/mchl.ashx?pk=MAGCINFO&sid=86")
## 86 seems to be the first one
## tcg ids:  [MTGSTCKS, MAGCINFO, SLICKCOLL]

## mtgstocks seems to go from = "http://mtgstocks.com/cards/1-30497"

  def stock_scraper
    range = [*20000..20010]
    bad_pages = {}
    successful_entries = 0
    mech = Mechanize.new
    mech.user_agent = "Melon MTG Pricescraper v0.1 - awkwardmelon@gmail.com - Please contact if the behavior of this bot is found to be problematic in any way."
    range.shuffle.each do |n|
      begin
        page = mech.get("http://mtgstocks.com/cards/#{n}")
      rescue Exception => e
        bad_pages["#{n}"] = e
        next
      end
      if page.code == "200"
        id = page.uri.path.scan(/\d+/).first.to_i
        card = page.at("title").text.chomp(" - MTGStocks.com")
        set = page.at(".indent").at("a").text
        price = page.at(".average").text.delete("$").to_f
        # what if it doesn't have .foilprice?
        foilprice = page.at(".foilprice").text.delete("$").to_f
        db_card = Card.where(name: card, set: get_scrape_set(set)).first
        db_card.update_column(:value, price)
        db_card.update_column(:foil_value, foilprice)
        if db_card.mtg_stocks_id == nil
          db_card.update_column(:mtg_stocks_id, id)
        end
        successful_entries += 1
      end
      sleep(rand(1.0..2.0))
    end
    puts bad_pages
    puts "Successful Entries = " + successful_entries.to_s
    puts Card.where(mtg_stocks_id: nil).count.to_s + "Unfinished Cards in DB"
  end

  def get_scrape_set(set)
    MTG_JSON_SETS.include?(set) ? set : MTGSTOCKS_TO_MTGJSON["#{set}"]
  end

  def get_api_set(set)
    MTG_JSON_SETS.include?(set) ? set : TCGPLAYER_TO_MTGJSON["#{set}"]
  end

  def tcg_price_update(range)
    pks = ["MTGSTCKS", "MAGCINFO"]
    base_url = "http://partner.tcgplayer.com/x3/mchl.ashx?pk=#{pks[1]}&sid="
    sids_found = []
    not_sids = []
    updated_cards = []
    problems = {}
    call_range = range
    loop_food = call_range - NOT_SIDS
    loop_food.each do |num|
      begin
        res = HTTParty.get(base_url + "#{num.to_s}")
        if res.include?("magic")
          sids_found << num
          info = res.scan(/store.tcgplayer.com.*?\?/).first.split("\/")
          set = get_api_set(info[-2].tr("-", " ").titlecase)
          card = info[-1].tr("-", " ").chomp("?").titlecase
          db_card = Card.where(name: card, set: set)
          price = res.scan(/\$\d*.\d*/)[1]
          if price == nil
            price = 0
          else
            price = price.delete("$").to_f
          end
          if db_card == []
            binding.pry
          else
            db_card.update_all(sid: num, value: price)
            updated_cards << db_card
          end
        else
          not_sids << num
          @not_sids |= [num]
        end
        call_range.delete(num)
      rescue e
        problems[num] = e
        next
      end
    end

    File.open('./public/WorkingSids.rb', 'w') do |f|
      f.write(JSON.dump(sids_found))
    end

    File.open('./public/UpdatedCards.rb', 'w') do |f|
      f.write(JSON.dump(updated_cards.map{|c| [c.name, c.set]}))
    end

    File.open('./public/NotSids.rb', 'w') do |f|
      f.write(JSON.dump(not_sids))
    end

    puts not_sids.count.to_s + "Empty Response"
    puts sids_found.count.to_s + "Full Response"
    puts updated_cards.count.to_s + "Updated Cards"
  end


  ## Should not need often or ever again...
  def make_card_db
    data = {}
    card_params = {}
    File.open("AllSets.json") do |f|
      data = JSON.parse(f.read)
    end
    data.each do |set|
      current_set = set.second["name"]
      set.second["cards"].each do |card|
        card_params["set"] = current_set
        card_params["name"] = card["name"]
        card_params["mtg_json_id"] = card["id"]
        card_params["rarity"] = card["rarity"]
        card_params["set_number"] = card["mciNumber"]
        Card.create(card_params)
      end
    end
  end

end