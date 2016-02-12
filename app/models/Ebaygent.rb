class Ebaygent
  require "csv"

  SINGLES_SMARTHEADERS = [
    "ConditionID=3000",
    "Format=FixedPrice",
    "Duration=30",
    "Location=56686",
    "ShippingType=Flat",
    "ShipToLocations=Worldwide",
    "ShippingService-1:Option=USPSFirstClass",
    "ShippingService-1:Cost=0",
    "ShippingService-1:FreeShipping=1",
    "ShippingService-1:AdditionalCost=0",
    "IntlShippingService-1:Option=USPSFirstClassMailInternational",
    "IntlShippingService-1:Cost=2",
    "IntlShippingService-1:AdditionalCost=0",
    "IntlShippingService-1:Locations=Worldwide",
    "DispatchTimeMax=1",
    "PayPalAccepted=1",
    "PayPalEmailAddress=awkwardmelon@gmail.com",
    "RefundOption=MoneyBackOrReplacement",
    "ReturnsAcceptedOption=ReturnsAccepted",
    "ReturnsWithinOption=Days_14",
    "ShippingCostPaidByOption=Buyer"
  ]

  SINGLES_HEADERS = [
    "Action",
    "Category",
    "PicURL",
    "Title",
    "Description",
    "Quantity",
    "StartPrice"
  ]


  def make_singles_csv(action)
    CSV.open("listings_#{Time.now.to_i}.csv", "wb") do |csv|
      csv << [SINGLES_HEADERS, SINGLES_SMARTHEADERS].flatten
      Listing.where(listed?: false).each do |l|
        array = [action, l.make_category, l.make_pic_url, l.make_title, l.make_description, l.quantity, l.price]
        csv << array
        # technically false, it has only been put in the csv, not put on ebay... should fix?
        l.update_column(:listed?, true) if action == "Add"
      end
    end
  end

end