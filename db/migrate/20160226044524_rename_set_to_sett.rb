class RenameSetToSett < ActiveRecord::Migration
  def change
    rename_table :sets, :setts
  end
end
