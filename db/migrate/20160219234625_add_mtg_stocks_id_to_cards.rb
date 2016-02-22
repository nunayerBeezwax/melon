class AddMtgStocksIdToCards < ActiveRecord::Migration
  def change
    add_column :cards, :mtg_stocks_id, :string
  end
end
