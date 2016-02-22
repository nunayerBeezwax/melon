class AddFoilpriceToCards < ActiveRecord::Migration
  def change
    add_column :cards, :foil_value, :float
  end
end
