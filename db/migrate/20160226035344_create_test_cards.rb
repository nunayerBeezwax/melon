class CreateTestCards < ActiveRecord::Migration
  def change
    enable_extension 'hstore'

    create_table :test_cards do |t|
      #mtg_json fields -> all the card data
      t.integer :mtg_json_id
      t.string :layout
      t.string :name, index: true
      t.text :names, array: true, default: []
      t.string :mana_cost
      t.string :cmc
      t.text :colors, array: true, default: []
      t.string :color_identity
      t.string :type
      t.string :supertypes
      t.string :types
      t.string :subtypes
      t.string :rarity, index: true
      t.string :text
      t.string :flavor
      t.string :artist
      t.string :number
      t.string :power
      t.string :toughness
      t.string :loyalty
      t.string :layout
      t.string :multiverse_id
      t.string :variations
      t.string :image_name
      t.string :watermark
      t.string :border
      t.string :timeshifted
      t.string :release_date

      # melon specific business data
      # the id for tcgplayer api
      t.integer :sid, index: true
      # the id for mtgstocks lookup
      t.integer :mtg_stocks_id, index: true
      # the url of the photobucket image
      t.string :image, index: true
      # simplified to help with various searches
      t.string :plaintext_name, index: true
      # if i ever maintain a full inventory
      t.integer :inventory_count
      t.string :location_code

      # pricing data
      t.float :value, index: true
      t.datetime :value_updated_at, index: true
      t.float :foil_value
      t.datetime :foil_value_updated_at
      t.hstore :historical_values
      t.hstore :snipes

      # relationships
      # belongs_to: :set, has_many: :listings
      t.belongs_to :set, index: true

      t.timestamps
    end
  end
end
