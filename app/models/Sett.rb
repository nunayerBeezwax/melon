class Sett < ActiveRecord::Base
  self.inheritance_column = nil
  has_many :cards

end