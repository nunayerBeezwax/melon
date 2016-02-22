class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :mtg_json_id
      t.string :name
      t.string :set
      t.string :artist
      t.string :color
      t.string :mana_cost
      t.string :rarity
      t.float :current_value
      t.string :set_number
    end
  end
end
