module AmazonSellerCentral
  class ListingSet < Array

    def find(selector)
      if Listing.is_asin?(selector)
        select{|e| e.asin == selector }
      else
        detect{|e| e.sku == selector }
      end
    end

  end
end
