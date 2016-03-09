class AddApiNameToCardsAgain < ActiveRecord::Migration
  def change
    add_column :cards, :api_name, :string
  end
end
