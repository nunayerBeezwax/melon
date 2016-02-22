class AddNotesToListing < ActiveRecord::Migration
  def change
    add_column :listings, :notes, :text
    add_column :listings, :type, :string
  end
end
