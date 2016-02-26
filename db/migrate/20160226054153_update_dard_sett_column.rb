class UpdateDardSettColumn < ActiveRecord::Migration
  def change
    rename_column :dards, :set_id, :sett_id
  end
end
