class ChangeCurrentValueToValue < ActiveRecord::Migration
  def change
    rename_column :cards, :current_value, :value
  end
end
