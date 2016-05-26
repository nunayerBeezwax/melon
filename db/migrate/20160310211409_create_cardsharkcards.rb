class CreateCardsharkcards < ActiveRecord::Migration
  def change
    create_table :cardsharkcards do |t|
      t.integer :card_id
      t.string :name
      t.string :set
      t.string :seller
      t.float :price
      t.integer :foil_quantity
      t.integer :quantity
      t.timestamps
    end
  end
end
