# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160226044524) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "cards", force: :cascade do |t|
    t.string  "mtg_json_id"
    t.string  "name"
    t.string  "set"
    t.string  "artist"
    t.string  "color"
    t.string  "mana_cost"
    t.string  "rarity"
    t.float   "value"
    t.string  "set_number"
    t.float   "foil_value"
    t.string  "mtg_stocks_id"
    t.integer "sid"
    t.string  "api_name"
  end

  create_table "dards", force: :cascade do |t|
    t.integer  "mtg_json_id"
    t.string   "layout"
    t.string   "name"
    t.text     "names",                 default: [], array: true
    t.string   "mana_cost"
    t.string   "cmc"
    t.text     "colors",                default: [], array: true
    t.string   "color_identity"
    t.string   "type"
    t.string   "supertypes"
    t.string   "types"
    t.string   "subtypes"
    t.string   "rarity"
    t.string   "text"
    t.string   "flavor"
    t.string   "artist"
    t.string   "number"
    t.string   "power"
    t.string   "toughness"
    t.string   "loyalty"
    t.string   "multiverse_id"
    t.string   "variations"
    t.string   "image_name"
    t.string   "watermark"
    t.string   "border"
    t.string   "timeshifted"
    t.string   "release_date"
    t.integer  "sid"
    t.integer  "mtg_stocks_id"
    t.string   "image"
    t.string   "plaintext_name"
    t.integer  "inventory_count"
    t.string   "location_code"
    t.float    "value"
    t.datetime "value_updated_at"
    t.float    "foil_value"
    t.datetime "foil_value_updated_at"
    t.hstore   "historical_values"
    t.hstore   "snipes"
    t.integer  "set_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dards", ["image"], name: "index_dards_on_image", using: :btree
  add_index "dards", ["mtg_stocks_id"], name: "index_dards_on_mtg_stocks_id", using: :btree
  add_index "dards", ["name"], name: "index_dards_on_name", using: :btree
  add_index "dards", ["plaintext_name"], name: "index_dards_on_plaintext_name", using: :btree
  add_index "dards", ["rarity"], name: "index_dards_on_rarity", using: :btree
  add_index "dards", ["set_id"], name: "index_dards_on_set_id", using: :btree
  add_index "dards", ["sid"], name: "index_dards_on_sid", using: :btree
  add_index "dards", ["value"], name: "index_dards_on_value", using: :btree
  add_index "dards", ["value_updated_at"], name: "index_dards_on_value_updated_at", using: :btree

  create_table "listings", force: :cascade do |t|
    t.string  "card"
    t.string  "series"
    t.integer "number"
    t.integer "quantity"
    t.float   "price"
    t.string  "pic_url"
    t.string  "color"
    t.string  "condition"
    t.boolean "listed?",   default: false
    t.text    "notes"
    t.string  "type"
    t.boolean "foil",      default: false
  end

  create_table "setts", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.string   "gatherer_code"
    t.string   "magic_cards_info_code"
    t.string   "release_date"
    t.string   "border"
    t.string   "type"
    t.string   "mkm_name"
    t.string   "mkm_id"
    t.integer  "number_of_cards"
    t.float    "value"
    t.datetime "value_updated_at"
    t.hstore   "historical_values"
    t.string   "plaintext_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
