class RenameDardsToCards < ActiveRecord::Migration
  def change
    rename_table :dards, :cards
  end
end
