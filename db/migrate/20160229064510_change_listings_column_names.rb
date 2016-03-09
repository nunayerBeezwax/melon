class ChangeListingsColumnNames < ActiveRecord::Migration
  def change
    rename_column :listings, :type, :listing_type
    rename_column :listings, :card, :title
  end
end
