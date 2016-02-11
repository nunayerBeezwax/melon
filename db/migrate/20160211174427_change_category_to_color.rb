class ChangeCategoryToColor < ActiveRecord::Migration
  def change
    rename_column :listings, :category, :color
    change_column :listings, :color, :string
  end
end
