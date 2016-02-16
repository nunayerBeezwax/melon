class Listing < ActiveRecord::Base

  # as I get into the autobuying and stuff, might want to set up a relationship where an Ebaytem will belong_to a listing
  # so I can keep track of how I'm doing

  CONDITIONS = {
    'NM': 'Near Mint',
    'EX': 'Excellent',
    'LP': 'Lightly Played',
    'Played': 'Played',
    'Damaged': 'Damaged'
  }

  CATEGORIES = {
    'Black': '158756',
    'Blue': '158755',
    'Green': '158758',
    'Red': '158757',
    'White': '158754',
    'Artifact': '158760',
    'Gold': '158759',
    'Land': '19115'
  }

  def make_title
    "#{self.card}" + " x" + "#{self.number}" + " - " + "#{self.series}" + " - " "#{self.number}" + "x - " + "#{self.condition}"
  end

  def make_pic_url
    "http://i825.photobucket.com/albums/zz177/hudson1949/magic/#{self.series.downcase.tr(' ', '_').tr('\'', '')}/#{self.card.gsub('FOIL', '').gsub(',', '').gsub('\'', '').strip.gsub(' ', '%20')}.jpg"
  end

  def make_category
    self.card.include?("FOIL") ? "49181" : CATEGORIES[self.color.to_sym]
  end

  def make_description
    "<link href='https://fonts.googleapis.com/css?family=Merriweather' rel='stylesheet' type='text/css'><div class='wrapper' style='height:100%;background-color:#e5e5e5;overflow:hidden'> <div id='banner' style='width:100%;height:350px;background:linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url(http://i825.photobucket.com/albums/zz177/hudson1949/the_awkward_melon/planeswalker_banner.jpg) no-repeat;background-size:100% 100%;'> <div class='headline' style='display:block;width=100%;text-align:center;padding-top:2.5em'> <font face='Merriweather' size='8' color='#fff'>The Awkward Melon MTG</font> </div><div class='banner-line' style='width:20%;padding-top:2em;margin-left:40%;border-bottom:1px solid white'></div><div class='banner-melon' style='height:160px;width:160px;background-color:#fff;margin:2em auto; background-image:url(http://i825.photobucket.com/albums/zz177/hudson1949/the_awkward_melon/square_melon.jpg); border-radius:50%; background-size:contain'></div></div><div class='listing'> <div class='item' style='width:50%;padding: 6em 0 3em 6em;float:left;text-align:center'> <font face='Merriweather' size='8'> <p>#{self.card + ' x' + self.number.to_s }</p><p>Series: #{self.series }</p><p>Condition: #{self.full_condition }</p><font size='6'> <p><a style='color:blue;text-decoration:none' href='http://stores.ebay.com/the-awkward-melon?_rdc=1'>The Awkward Melon's eBay Store</a></p></font> <div class='info' style='margin-top:2em'> <div class='shipping' style='width:50%;float:left;background-color:#aaaaaa;border:1px solid black'> <font size='3'> <h2>Shipping</h2> <p>*</p><p>Shipping to the United States is <u>free</u> for all Singles orders.</p><p>Worldwide Shipping available: $2 per tweleve cards ordered.</p><p>We ship 6 days a week. Most orders ship same or next day.</p></font> </div><div class='service' style='width:48%;float:left;background-color:#aaaaaa;border:1px solid black'> <font size='3'> <h2>Customer Service</h2> <p>*</p><p>The Awkward Melon has the best service in the business.</p><p>Contact through the eBay message system.</p><p>I will do whatever it takes to make you satisfied with your order!</p></font> </div></div></font> </div><div class='image' style='display:block; width:40%; float:right; padding:6em 0'> <img src=#{ self.make_pic_url } border='0'> </div></div><div id='footer' style='width:100%;height:350px;background:linear-gradient(rgba(0, 0, 0, 0.8), rgba(0, 0, 0, 0.8)), url(http://i825.photobucket.com/albums/zz177/hudson1949/the_awkward_melon/footer.jpg) no-repeat;background-size:100% 100%;float:left'> <div class='company' style='padding:2em;margin:1em;float:left;width:20%;background:linear-gradient(rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.3))'> <font size='3' color='white'> <p>The Awkward Melon is a small business with high standards. We strive to be the best Magic seller on eBay, with accurate listings, quick & safe & reliable shipping, and the most personal customer service in the business.<br>We are located in pristine, beautiful northern Minnesota & we've been in business for over 10 years. </p></font> </div><div class='purchasing' style='padding:2em;margin:5em;float:right;width:50%;background:linear-gradient(rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.3))'> <font size='3' color='white'> <h1>We're Always Buying!</h1> <p>In order to keep up our inventory, The Awkward Melon is always looking to purchase Magic card singles and collections. If you're looking to sell, hit me up over eBay Messages and let us know what you have to sell and we will work with you to make a fair deal.</p></font> </div></div></div>"
  end

  def full_condition
    CONDITIONS[self.condition.to_sym]
  end

end