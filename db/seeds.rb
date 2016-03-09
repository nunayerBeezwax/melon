# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def make_setts
  data = json_to_hash("data/AllSets.json")
  sett_params = {}
  data.each do |sett|
    sett = sett.second
    sett_params["name"] = sett["name"]
    sett_params["code"] = sett["code"]
    sett_params["gatherer_code"] = sett["gathererCode"]
    sett_params["magic_cards_info_code"] = sett["magicCardsInfoCode"]
    sett_params["release_date"] = sett["releaseDate"]
    sett_params["border"] = sett["border"]
    sett_params["type"] = sett["type"]
    sett_params["mkm_name"] = sett["mkm_name"]
    sett_params["mkm_id"] = sett["mkm_id"]
    sett_params["mkm_name"] = sett["mkm_name"]
    sett_params["number_of_cards"] = sett["cards"].count
    sett_params["plaintext_name"] = ActiveSupport::Inflector.transliterate(sett["name"].downcase.gsub(/[^a-z0-9\s\"]/i, ''))
    Sett.create(sett_params)
  end
end

def make_cards
  data = json_to_hash("data/AllSets.json")
  card_params = {}
  data.each do |set|
    sett = Sett.find_by_name(set.second["name"])
    set.second["cards"].each do |card|
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
end

def json_to_hash(filename)
  data = {}
  File.open(filename) do |f|
    data = JSON.parse(f.read)
  end
  data
end
