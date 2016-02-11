class AddListedToListings < ActiveRecord::Migration
  def change
    add_column :listings, :listed?, :boolean, default: false
  end
end
