class CreateSets < ActiveRecord::Migration
  def change
    create_table :sets do |t|
      t.string :name
      t.string :code
      t.string :gatherer_code
      t.string :magic_cards_info_code
      t.string :release_date
      t.string :border
      t.string :type
      t.string :mkm_name
      t.string :mkm_id
      t.integer :number_of_cards
      t.float :value
      t.datetime :value_updated_at
      t.hstore :historical_values
      t.string :plaintext_name
      t.timestamps
    end
  end
end
