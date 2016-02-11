class Listings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string :card
      t.string :series
      t.integer :number
      t.integer :quantity
      t.float :price
      t.string :pic_url
      t.integer :category
      t.string :condition
    end
  end
end
