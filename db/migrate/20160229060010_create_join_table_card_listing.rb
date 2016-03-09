class CreateJoinTableCardListing < ActiveRecord::Migration
  def change
    create_join_table :cards, :listings do |t|
      # t.index [:card_id, :listing_id]
      # t.index [:listing_id, :card_id]
    end
  end
end
