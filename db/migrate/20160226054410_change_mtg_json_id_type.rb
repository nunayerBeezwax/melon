class ChangeMtgJsonIdType < ActiveRecord::Migration
  def change
    change_column :dards, :mtg_json_id, :string
  end
end
