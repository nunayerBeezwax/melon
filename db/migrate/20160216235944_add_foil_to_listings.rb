class AddFoilToListings < ActiveRecord::Migration
  def change
    add_column :listings, :foil?, :boolean, default: false
  end
end
