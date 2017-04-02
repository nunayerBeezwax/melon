class Ebaygent
  require "csv"
  require "open-uri"
  require "capybara"

  def make_singles_csv(action)
    CSV.open("listings_#{Time.now.to_i}.csv", "wb") do |csv|
      csv << [SINGLES_HEADERS, SINGLES_SMARTHEADERS].flatten
      Listing.where(listed?: false).each do |l|
        array = [action, l.make_category, l.cards.first.image, l.make_title, l.make_description, l.quantity, l.price]
        csv << array
        # technically false, it has only been put in the csv, not put on ebay... should fix?
        l.update_column(:listed?, true) if action == "Add"
      end
    end
  end

  def make_lot_csv(action)
    CSV.open("listings_#{Time.now.to_i}.csv", "wb") do |csv|
      csv << [SINGLES_HEADERS, LOT_SMARTHEADERS].flatten
      Listing.where(listed?: false).each do |l|
        array = [action, '38292', l.pic_url, l.title, l.make_description, l.quantity, l.price]
        csv << array
        # technically false, it has only been put in the csv, not put on ebay... should fix?
        l.update_column(:listed?, true) if action == "Add"
      end
    end
  end

  def make_auction_csv(action)
    CSV.open("listings_#{Time.now.to_i}.csv", "wb") do |csv|
      csv << [SINGLES_HEADERS, AUCTION_SMARTHEADERS].flatten
      Listing.where(listed?: false).each do |l|
        array = [action, l.make_category, l.cards.first.image, l.make_title, l.make_description, l.quantity, l.price]
        csv << array
        # technically false, it has only been put in the csv, not put on ebay... should fix?
        l.update_column(:listed?, true) if action == "Add"
      end
    end
  end

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
    card_link = driver.find_element(:link_text, listing.cards.first.name)
    card_link.click
    begin
      low = driver.find_element(:class, "low").text.gsub("$", "").to_f
      average = driver.find_element(:class, "average").text.gsub("$", "").to_f
      high = driver.find_element(:class, "high").text.gsub("$", "").to_f
    rescue
      low = "No Low"
      average = "No Average"
      high = "No High"
    end
    begin
      foil = driver.find_element(:class, "foilprice").text.gsub("$", "").to_f
    rescue Selenium::WebDriver::Error::NoSuchElementError
      foil = "No Foil Exists"
    end
    driver.close
    prices = { low: low, average: average, high: high, foil: foil }
    return OpenStruct.new prices
    redirect_to listings_url
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
      price = temp > 2.99 ? temp : 2.99
      l.update_column(:price, price)
    end
  end

  def batch_value(listings)
    listings.each do |l|
      card = l.cards.first
      if l.foil
        temp = price_listing(l)
      elsif card.value
        temp = card.value * l.number
      else
        temp = price_listing(l)
      end
      temp = temp.ceil.to_f - 0.01
      temp = temp - 1 if l.condition == "EX"
      temp = temp - 2 if !["NM", "EX"].include?(l.condition)
      price = temp > 2.99 ? temp : 2.99
      l.update_attribute(:price, price)
    end
  end

  def current_listings(string)
    finder = Rebay::Finding.new
    response = finder.find_items_by_keywords({:keywords => string})
    #array of items (max 100?)
    response.results
    #price
    response.results.first["sellingStatus"]["currentPrice"]["__value__"].to_f
  end

  def by_category(num)
    finder = Rebay::Finding.new
    response = finder.find_items_by_category({categoryId: 158756, :SortOrderType => "EndTimeSoonest"})
  end

  def current_listings_by_cat(string)
    finder = Rebay::Finding.new
    response = finder.find_items_advanced({keywords: string, categoryId: 19107})
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

  def make_ebay_url(page)
    url = ""
    url += "http://svcs.ebay.com/services/search/FindingService/v1?"
    url += "OPERATION-NAME=findItemsByCategory"
    url += "&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=HarlandH-af4d-46b8-929d-c6b0a5cacfc2"
    url += "&categoryId=38292"
    url += "&paginationInput.pageNumber=#{page}"
    url += "&sortOrder=EndTimeSoonest" #StartTimeNewest
    url += "&itemFilter(0).name=ListingType&itemFilter(0).value(0)=Auction"
  end

  def ebay_grab
    responses = []
    items = []
    [1].each do |num|
      page = HTTParty.get(self.make_ebay_url(num))
      responses << page
    end
    responses.each do |res|
      items << self.pull_items(res)
    end
    items.flatten.uniq
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
    ditch_crap(clean_items)
  end

  # must avoid proxies and altered art, etc.
  def ditch_crap(clean_items)
    clean_items.delete_if do |item|
      if !!(item["title"].match(/proxy/i)) || !!(item["title"].match(/altered/i))
        true
      end
    end
    clean_items
  end

  # Here is how you get 1000 ending soonest ebay auctions from individual cards category
  def hit_ebay
    self.gimmie_the_goods(self.ebay_grab)
  end

  def snipes
    snipes = []
    self.hit_ebay.each do |item|
      begin
        sets = self.infer_set(item["title"])
        if sets.count == 1
          maybe_cards = sets.first.cards.where(name: self.infer_card(item["title"]).first.name)
          if maybe_cards.count == 1
            card = maybe_cards.first
          end
        end
        quantity = infer_quantity(item["title"]).to_i
        if card && card.value
          if (card.value * quantity) > ((item["price"].to_f + item["shipping_cost"].to_f) * quantity)
            snipes << item
          end
        end
      rescue
        next
      end
    end
    snipes
  end

  # so first thing we're going to do is get the set.  then we do this:
  # set.cards.where(name: (a.infer_card(items[x]).first.name)
  # that should give us a card.  Then we can look at card.value * infer_quantity(item[x]) compared to item[x].price

  def card_from_line(line)
    infer_set(line)
    infer_card(line)
    infer_foil(line)
  end

  def infer_set(string)
    hits = []
    Sett.all.each do |set|
      if !!(string.match(/#{set.name}/i))
        hits << set
      end
    end
    if hits.count > 1
      hits.sort { |x,y| x.name.length <=> y.name.length }.last
    else
      hits
    end
  end

  def infer_card(string)
    hits = []
    Card.all.each do |card|
      next if card.name == "Foil"
      if !!(string.match(/#{card.name}/i))
        hits << card
      end
    end
    if hits.count > 1
      hits.sort { |x,y| x.name.length <=> y.name.length }.last
    else
      hits
    end
  end

  def infer_quantity(string)
    nums = string.scan(/\d/)
    nums.max || "1"
  end

  def infer_foil(string)
    !!string.match(/foil/i)
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

  def stock_scraper(range)
    bad_pages = {}
    hits = {}
    mech = Mechanize.new
    mech.user_agent = "Melon MTG Scraper v0.1 - awkwardmelon@gmail.com - Please contact if the behavior of this bot is found to be problematic in any way."
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
        hits["Card: #{card}" + " " + "Set: #{set}"] = n
      end
      puts "#{card} - #{set} - #{n}"
      sleep(rand(1.0..2.0))
    end
    File.open("mtgStocksNumberScrape.rb", "w") do |f|
      f.write(JSON.dump(hits))
    end
    return hits
  end

  def get_scrape_set(set)
    MTG_JSON_SETS.include?(set) ? set : MTGSTOCKS_TO_MTGJSON["#{set}"]
  end

  def db_mtgstocks_ids(file)
    file = File.read("#{file}")
    data = JSON.parse(file)
    fails = []
    data.each do |d|
      name = d.first[/Card:\s(.*?)Set:/,1].strip
      set = d.first[/Set:\s(.*)/,1].strip
      card = Card.where(name: name, setname: get_scrape_set(set)).first
      if card
        card.update_attribute(:mtg_stocks_id, d.second)
      else
        fails << d
      end
    end
  end

  def tcg_sid_collector(range)
    start = Time.now
    pks = ["MTGSTCKS", "MAGCINFO"]
    base_url = "http://partner.tcgplayer.com/x3/mchl.ashx?pk=#{pks[1]}&sid="
    misses = []
    hits = {}
    problems = {}
    range.each do |num|
      begin
        res = HTTParty.get(base_url + "#{num.to_s}")
        if res.include?("magic")
          hits[num] = res
        else
          misses |= [num]
        end
      rescue Exception => e
        problems[num] = e
      end
    end

    File.open("resultsOn#{range[0]}-#{range[-1]}.rb", "w") do |f|
      f.write(JSON.dump(hits))
    end

    the_end = Time.now
    puts "It took " + (the_end - start).to_s + " seconds to process " + range.count.to_s + " numbers."
    return [misses, problems]
  end

  def parse_tcg_results(file)
    misses = []
    successes = 0
    File.open(file) do |f|
      items = JSON.load(f)
      items.each do |k, v|
        sid = k
        info = v.scan(/store.tcgplayer.com.*?\?/).first.split("\/")
        set = get_api_set(get_set_name(info))
        card = get_card_name(info)
        db_card = find_card(set, card)
        if db_card != []
          db_card.first.update_attribute(:sid, sid)
          successes += 1
        else
          misses << sid
        end
      end
    end
    puts successes.to_s + " database updates were made"
    misses
  end

  def make_api_names
    Card.all.each do |c|
      c.update_column(:api_name, c.name.downcase.gsub("-", " ").gsub(/[^a-z0-9\s\"]/i, ''))
    end
  end

  def find_card(set, card)
    Card.where(api_name: card).where('lower(setname) = ?', get_api_set(set))
  end

  def get_price(chunk)
    price = chunk.scan(/\$\d*.\d*/)[1] || "0"
    price.delete("$").to_f
  end

  def get_set_name(info)
    get_api_set(info[-2].tr("-", " ").downcase)
  end

  def get_api_set(set)
    downcase = MTG_JSON_SETS.map(&:downcase)
    begin
      downcase.include?(set) ? set : TCGPLAYER_TO_MTGJSON["#{set}"].downcase
    rescue
      "dummy"
    end
  end

  def get_card_name(info)
    info[-1].tr("-", " ").chomp("?").downcase
  end

  def get_tcg_price_update
    Card.where.not(sid: nil).each do |c|
      url = "http://partner.tcgplayer.com/x3/mchl.ashx?pk=MAGCINFO&sid=#{c.sid}"
      begin
        info = HTTParty.get(url)
      rescue
        next
      end
      new_price = get_price(info)
      old_price = c.value
      old_update_time = c.value_updated_at
      c.update_attributes(value: new_price, value_updated_at: Time.now)
      if c.historical_values
        c.update(:historical_values => c.historical_values.merge({ old_update_time.to_s => old_price }))
      else
        c.update_attribute(:historical_values, {old_update_time.to_s => old_price})
      end
    end
  end


  ## Cardshark poking w/Selenium

  def get_rares_by_seller(sellername)
    driver = Selenium::WebDriver.for(:firefox)
    page = driver.get("http://www.cardshark.com/Sellers/Cards-by-Seller.aspx?Game=Magic&Seller=#{sellername}")
    Selenium::WebDriver::Support::Select.new(driver.find_element(:id, "ctl00_ContentPlaceHolder1_ddlPageSize")).select_by(:text, "All cards")
    Selenium::WebDriver::Support::Select.new(driver.find_element(:id, "ctl00_ContentPlaceHolder1_ddlFilterRarity")).select_by(:text, "Rares")
    driver.find_element(:id, "ctl00_ContentPlaceHolder1_ibFilter").click
    table = []
    table << driver.find_elements(:class, "tableViewHeader")
    table << driver.find_elements(:class, "tableViewRow")
    headers = table.first.first.text.strip.split(" ")
    data = fix_cardshark_table_data(table.second)
    CSV.open("cardshark_seller_#{sellername}_rares.csv", "wb") do |csv|
      csv << headers
      data.each do |row|
        csv << row
      end
    end
  end

  def fix_cardshark_table_data(data)
    clean_data = []
    data.each do |item|
      final_answer = []
      arr = item.text.split(" ")
      card_lookup = ""
      card = nil
      until card do
        card_lookup += arr.shift
        card = Card.find_by_name(card_lookup)
        card_lookup += " "
      end
      final_answer << card_lookup
      set_lookup = ""
      sett = nil
      until sett do
        set_lookup += arr.shift
        sett = Sett.find_by_name(set_lookup)
        set_lookup += " "
      end
      final_answer << set_lookup
      final_answer << arr.shift
      final_answer << arr.shift
      if arr[0] == "Near"
        nm = ""
        nm += arr.shift
        nm += arr.shift
        final_answer << nm
      else
        final_answer << arr.shift
      end
      if arr[0] == "Foil"
        final_answer << arr.shift
      else
        final_answer << "Nonfoil"
      end
      final_answer << arr.shift
      if arr[0][0] == "$"
        final_answer << ""
      else
        final_answer << arr.shift
      end
      final_answer << arr.shift
      final_answer << arr.shift
      clean_data << final_answer
    end
    clean_data
  end

  # look at this  http://www.mtgstocks.com/cards/22129

  def get_cardshark_dump
    Cardsharkcard.delete_all
    data = HTTParty.get("http://www.cardshark.com/API/the_awkward_melon/Get-Full-Feed.aspx?apiKey=55B5C472-33BA-4908-91B7-A02A4C67BD24")
    File.open("cardshark.tsv", "w") do |f|
      f.write(data)
    end
    array = CSV.read("cardshark.tsv", {col_sep: "\t", quote_char: "|"})
    array[1..-1].each do |row|
      Cardsharkcard.create({
        card_id: row[0],
        name: row[1],
        set: row[2],
        seller: row[3],
        price: row[4],
        foil_quantity: row[5],
        quantity: row[6]
      })
    end
    data
  end

  #  First make the Sett (by hand so far)!!!
  #  Card.create by individual set.  Download the MTG.json for that set, put the file in data.  Then call
  #  Ebaygent.make_cards(file) and send in the filename.  Should do it.

  def make_cards_by_set(file)
    data = json_to_hash("data/#{file}")
    card_params = {}
    sett = Sett.find_by_name(data.first[1])
    data["cards"].each do |card|
      card_params["artist"] = card["artist"]
      card_params["mtg_json_id"] = card["id"]
      card_params["cmc"] = card["cmc"]
      card_params["color_identity"] = card["colorIdentity"]
      card_params["colors"] = card["colors"]
      card_params["flavor"] = card["flavor"]
      card_params["image_name"] = card["imageName"]
      card_params["layout"] = card["layout"]
      card_params["mana_cost"] = card["manaCost"]
      card_params["names"] = card["names"]
      card_params["number"] = card["mciNumber"]
      card_params["multiverse_id"] = card["multiverseId"]
      card_params["name"] = card["name"]
      card_params["power"] = card["power"]
      card_params["rarity"] = card["rarity"]
      card_params["subtypes"] = card["subtypes"]
      card_params["text"] = card["text"]
      card_params["toughness"] = card["toughness"]
      card_params["type"] = card["type"]
      card_params["types"] = card["types"]
      card_params["plaintext_name"] = ActiveSupport::Inflector.transliterate(card["name"].downcase.gsub(/[^a-z0-9\s\"]/i, ''))
      card = Card.create(card_params)
      sett.cards << card
      card.update_attributes(image: card.make_pic_url, setname: card.sett.name)
    end
  end

  def json_to_hash(filename)
    data = {}
    File.open(filename) do |f|
      data = JSON.parse(f.read)
    end
    data
  end

end

