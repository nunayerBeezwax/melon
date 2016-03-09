class Card < ActiveRecord::Base

  self.inheritance_column = nil

  belongs_to :sett
  has_and_belongs_to_many :listings

  def self.update_pic_url
    Card.all.each { |c| c.update_attribute(:image, c.make_pic_url) }
  end

  def make_pic_url
    url = ""
    url += "http://i825.photobucket.com/albums/zz177/hudson1949/magic/"
    url += self.sett.plaintext_name.gsub(" ", "_")
    url += "/#{self.name.gsub("\'", "").gsub(",", "").gsub(" ", "%20")}.jpg"
    url
  end
end
