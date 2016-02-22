class AddTcgSidToCards < ActiveRecord::Migration
  def change
    add_column :cards, :sid, :integer
  end
end
