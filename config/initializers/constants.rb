CONDITIONS = {
'NM': 'Near Mint',
'EX': 'Excellent',
'LP': 'Lightly Played',
'Played': 'Played',
'Damaged': 'Damaged'
}

CATEGORIES = {
'Black': '38292',
'Blue': '38292',
'Green': '38292',
'Red': '38292',
'White': '38292',
'Artifact': '38292',
'Gold': '38292',
'Land': '38292'
}

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

LOT_SMARTHEADERS = [
  "ConditionID=3000",
  "Format=FixedPrice",
  "Duration=30",
  "Location=56686",
  "ShippingType=Flat",
  "ShipToLocations=US",
  "ShippingService-1:Option=USPSFirstClass",
  "ShippingService-1:Cost=0",
  "ShippingService-1:FreeShipping=1",
  "ShippingService-1:AdditionalCost=0",
  "DispatchTimeMax=1",
  "PayPalAccepted=1",
  "PayPalEmailAddress=awkwardmelon@gmail.com",
  "RefundOption=MoneyBackOrReplacement",
  "ReturnsAcceptedOption=ReturnsAccepted",
  "ReturnsWithinOption=Days_14",
  "ShippingCostPaidByOption=Buyer"
]

AUCTION_SMARTHEADERS = [
  "ConditionID=3000",
  "Format=Auction",
  "Duration=7",
  "Location=56686",
  "ShippingType=Flat",
  "ShipToLocations=Worldwide",
  "ShippingService-1:Option=USPSFirstClass",
  "ShippingService-1:Cost=.99",
  "ShippingService-1:AdditionalCost=0",
  "IntlShippingService-1:Option=USPSFirstClassMailInternational",
  "IntlShippingService-1:Cost=2",
  "IntlShippingService-1:AdditionalCost=1",
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
  "Limited Edition Alpha" => "Alpha Edition",
  "Battle Royale" => "Battle Royale Box Set",
  "Beatdown" => "Beatdown Box Set",
  "Limited Edition Beta" => "Beta Edition",
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
TCGPLAYER_TO_MTGJSON = {"magic 2010 (m10)"=>"Magic 2010",
   "magic 2011 m11"=>"Magic 2011",
   "magic 2012 m12"=>"Magic 2012",
   "magic 2013 m13"=>"Magic 2013",
   "magic 2014 m14"=>"Magic 2014",
   "magic 2015 m15"=>"Magic 2015",
   "sixth edition"=>"Classic Sixth Edition",
   "7th edition"=>"Seventh Edition",
   "8th edition"=>"Eighth Edition",
   "9th edition"=>"Ninth Edition",
   "10th edition"=>"Tenth Edition",
   "alpha edition"=>"Limited Edition Alpha",
   "beta edition"=>"Limited Edition Beta",
   "anthology"=>"Duel Decks: Anthology",
   "duel decks zendikar vs eldrazi"=>"Duel Decks: Zendikar vs. Eldrazi",
   "duel decks elspeth vs kiora"=>"Duel Decks: Elspeth vs. Kiora",
   "duel decks speed vs cunning"=>"Duel Decks: Speed vs. Cunning",
   "duel decks ajani vs nicol bolas"=>"Duel Decks: Ajani vs. Nicol Bolas",
   "duel decks divine vs demonic"=>"Duel Decks: Divine vs. Demonic",
   "duel decks elspeth vs tezzeret"=>"Duel Decks: Elspeth vs. Tezzeret",
   "duel decks elves vs goblins"=>"Duel Decks: Elves vs. Goblins",
   "duel decks garruk vs liliana"=>"Duel Decks: Garruk vs. Liliana",
   "duel decks heroes vs monsters"=>"Duel Decks: Heroes vs. Monsters",
   "duel decks izzet vs golgari"=>"Duel Decks: Izzet vs. Golgari",
   "duel decks jace vs chandra"=>"Duel Decks: Jace vs. Chandra",
   "duel decks jace vs vraska"=>"Duel Decks: Jace vs. Vraska",
   "duel decks knights vs dragons"=>"Duel Decks: Knights vs. Dragons",
   "duel decks sorin vs tibalt"=>"Duel Decks: Sorin vs. Tibalt",
   "duel decks venser vs koth"=>"Duel Decks: Venser vs. Koth",
   "pds: graveborn"=>"Premium Deck Series: Graveborn",
   "pds: fire and lightning"=>"Premium Deck Series: Fire and Lightning",
   "pds: slivers"=>"Premium Deck Series: Slivers",
   "champs promos"=>"Champs and States",
   "fnm promos"=>"Friday Night Magic",
   "game day promos"=>"Magic Game Day",
   "gateway promos"=>"Gateway",
   "grand prix promos"=>"Grand Prix",
   "judge promos"=>"Judge Gift Program",
   "launch party cards"=>"Launch Parties",
   "media promos"=>"Media Inserts",
   "guru lands"=>"Guru",
   "european lands"=>"Eurpoean Land Program",
   "jss/mss promos"=>"Super Series",
   "magic modern event deck"=>"Modern Event Deck 2014",
   "prerelease cards"=>"Prerelease Events",
   "pro tour promos"=>"Pro Tour",
   "ravnica"=>"Ravnica: City of Guilds",
   "release event cards"=>"Release Events",
   "wpn promos"=>"World Magic Cup Qualifiers",
   "urzas destiny"=>"Urza's Destiny",
   "urzas legacy"=>"Urza's Legacy",
   "urzas saga"=>"Urza's Saga"
 }