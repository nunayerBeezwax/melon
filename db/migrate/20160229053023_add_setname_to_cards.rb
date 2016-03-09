class AddSetnameToCards < ActiveRecord::Migration
  def change
    add_column :cards, :setname, :string
  end
end
