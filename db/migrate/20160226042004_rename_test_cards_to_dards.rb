class RenameTestCardsToDards < ActiveRecord::Migration
  def change
    rename_table :test_cards, :dards
  end
end
