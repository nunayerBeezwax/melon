class Dard < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :sett

  SETT_EXCEPTIONS = {
    "fourth edition" => "4th edition",
    "fifth edition" => "5th edition",
    "classic sixth edition" => "6th edition",
    "seventh edition" => "7th edition",
    "eighth edition" => "8th edition",
    "ninth edition" => "9th edition",
    "tenth edition" => "10th edition",
    "magic 2010 core set" => "magic core set 2010",
    "magic 2011 core set" => "magic core set 2011",
    "magic 2012 core set" => "magic core set 2012",
    "magic 2013 core set" => "magic core set 2013",
    "magic 2014 core set" => "magic core set 2014",
    "magic 2015 core set" => "magic core set 2015"
  }

  def self.update_pic_url
    Dard.all.each { |d| d.update_attribute(:image, d.make_pic_url) }
  end

  def make_pic_url
    url = ""
    url += "http://i825.photobucket.com/albums/zz177/hudson1949/magic/"
    url += get_sett.gsub(" ", "_")
    url += "/#{self.name.gsub("\'", "").gsub(" ", "%20")}.jpg"
    url
  end

  def get_sett
    SETT_EXCEPTIONS.keys.include?(self.sett.plaintext_name) ? SETT_EXCEPTIONS[self.sett.plaintext_name] : self.sett.plaintext_name
  end

end