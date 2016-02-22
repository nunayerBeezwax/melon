class ChangeFoil < ActiveRecord::Migration
  def change
    rename_column :listings, :foil?, :foil
  end
end
